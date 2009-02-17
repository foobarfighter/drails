dojo.provide("drails.common");
dojo.require("drails.monkey");
dojo.require("dojo.dnd.move");

drails._insertionMap = {
	"top":		 "first",
	"bottom":	 "last",
	"before":	 "before",
	"after":	 "after"
};

drails._xhrMap = {
	"asynchronous": [ "sync", function(v) { return !v; } ],
	"method":				[ "method", function(v) { return v.toLowerCase(); } ],
	"insertion":		[ "place", function(v) { return drails._insertionMap[v] }],
	"parameters":		[ "content", function(v) { return dojo.queryToObject(v); } ],
	"evalScripts":	[ "noop", function(v) { return null; } ]
};

drails._xhrCallbackMap = {
	"onUninitialized":	null,
	"onLoading":				null,
	"onLoaded":					null,
	"onInteractive":		null,
	"onComplete":				null,		// handle ?
	"onFailure":				"error",
	"onSuccess":				"load"
	// TODO 100..599
};

dojo.declare("drails._base", null, {
	transformCallbacks: function(url, xhrArgs) {
		var dojoXhrArgs = { url: url };
		for (var protoCallback in xhrArgs) {
			var dojoCallback = drails._xhrCallbackMap[protoCallback];
			if (dojoCallback) {		// Found callback mapping
				// If a prototype callback handler exists on this object
				if (this[protoCallback]) {
					dojo.connect(dojoXhrArgs, dojoCallback, this, protoCallback);
					if (xhrArgs[protoCallback]){
						dojo.connect(this, protoCallback, xhrArgs[protoCallback]);	// Connect the callback to the currently existing callback
					}
				} else if (xhrArgs[protoCallback]) {
					dojoXhrArgs[dojoCallback] = xhrArgs[protoCallback];
				}
			} else {							// Did not find a callback mapping
				this.unsupportedOperation(protoCallback);
			}
		}
		return dojoXhrArgs;
	},
	
	transformSettings: function(xhrArgs){
		var dojoXhrArgs = {};
		for (var setting in xhrArgs){
			var dojoSetting = drails._xhrMap[setting];
			if (dojoSetting){
				var value = dojoSetting;
				if (dojo.isArray(value)) {
					dojoSetting = value[0];
					value = value[1](xhrArgs[setting]);
				}
				else {
					value = xhrArgs[setting];
				}
				dojoXhrArgs[dojoSetting] = value;
				delete xhrArgs[setting];
			}
		}
		return dojoXhrArgs;
	},
	
	unsupportedOperation: function(callbackName){
		throw(callbackName + " is not a supported drails operation");
	}
});

dojo.declare("drails.Request", [drails._base], {
	_requestOnConstruction: true,
	_transformedArgs: null,
	_transformedMethod: null,
	
	constructor: function(url, xhrArgs){
		if (this._requestOnConstruction){
			this.xhr(url, xhrArgs);
		}
	},
	
	xhr: function(url, xhrArgs) {
		var dojoXhrArgs = {};
		
		if (xhrArgs) {
			dojo.mixin(dojoXhrArgs, this.transformSettings(xhrArgs));
			dojo.mixin(dojoXhrArgs, this.transformCallbacks(url, xhrArgs));
		}
		this._transformedMethod = dojoXhrArgs['method'] || 'get';
		this._transformedArgs = dojoXhrArgs;
		dojo.xhr(this._transformedMethod, this._transformedArgs);
	}
});


dojo.declare("drails.Updater", [drails.Request], {
	
	_requestOnConstruction: false,
	_successNode: null,
	_failureNode: null,
	
	constructor: function(target, url, xhrArgs) {
		xhrArgs = xhrArgs || {};
		xhrArgs['onSuccess'] = xhrArgs['onSuccess'] || function() {};
		xhrArgs['onFailure'] = xhrArgs['onFailure'] || function() {};

		if (target) this.interpolateTargets(target);
		this.xhr(url, xhrArgs);
	},
	
	onSuccess: function(response, ioArgs) {
		this._placeHTML(response, ioArgs, this._successNode);
	},
	
	onFailure: function(response, ioArgs) {
		this._placeHTML(response, ioArgs, this._failureNode);
	},
	
	interpolateTargets: function(target){
		if (typeof target == "string") {
			this._successNode = this._failureNode = target;
		} else if (typeof target == "object") {
			this._successNode = target["success"];
			this._failureNode = target["failure"];
		}
		else {
			throw new Error("Invalid target type");
		}
	},
	
	_placeHTML: function(response, ioArgs, target) {
		if (target){
			var node = dojo.byId(target);
			if (ioArgs.args['place']) {
				var nodeHTML = dojo.doc.createElement("span");
				nodeHTML.innerHTML = response.toString();
				dojo.place(dojo.clone(nodeHTML.firstChild), node, ioArgs.args['place']);
			} else {
				node.innerHTML = response.toString();
			}
		}
	}
	
});


dojo.declare("drails.PeriodicalExecuter", null, {
	constructor: function(callback, frequency) {
		this.callback = callback;
		this.frequency = frequency;
		this.currentlyExecuting = false;

		this.registerCallback();
	},

	registerCallback: function() {
		var self = this;
		dojo.connect(self, "onTimerEvent", function() {
				if (!self.currentlyExecuting) {
					try {
						self.currentlyExecuting = true;
						self.execute();
					} finally {
						self.currentlyExecuting = false;
					}
				}
			});
		self.timer = setInterval(self.onTimerEvent, self.frequency * 1000);
	},
	
	execute: function() {
		// Weird, why pass "self" as an argument if callback is called in "self"'s context?
		// (Prototype apparently does this).	Am I missing something?
		this.callback(this);
	},

	stop: function() {
		if (!this.timer) return;
		clearInterval(this.timer);
		this.timer = null;
	},
	
	// Event hook... connect away :)
	onTimerEvent: function() {
	}
});

// Due to API inconsistency in the constructor, we can't subclass PeriodicalExecuter like Prototype does
// TODO: Reimplement as a mixin
dojo.declare("drails.TimedObserver", null, {
	element: null,
	executer: null,
	callback: null,
	lastValue: null,
	
	constructor: function(element, frequency, callback) {
		this.callback = callback;
		this.element = dojo.byId(element);
		this.executer = new drails.PeriodicalExecuter(dojo.hitch(this, "execute"), frequency);
		dojo.connect(this, "stop", this.executer, "stop");
		dojo.connect(this.executer, "onTimerEvent", this, "onTimerEvent");
	},
	
	execute: function(executer) {
		var value = this.getValue();
		if (dojo.isString(this.lastValue) && dojo.isString(value) ?
				this.lastValue != value : String(this.lastValue) != String(value)) {
			this.callback(this.element, value);
			this.lastValue = value;
		}
	},
	
	stop: function(){
	},
	
	onTimerEvent: function(){
	},
	
	getValue: function() {
		throw new Error("[" + this.declaredClass + "] getValue is an abstract method");
	}
});

dojo.declare("drails.Form.Element.Observer", [drails.TimedObserver], {
	getValue: function(){
		// TODO: Does this return field=value in prototype?
		return dojo.fieldToObject(this.element);
	}
});

dojo.declare("drails.Form.Observer", [drails.TimedObserver], {
	getValue: function(){
		// TODO: does this returns a query string in prototype?		 
		return dojo.formToObject(this.element);
	}
});


dojo.declare("drails.EventObserver", null, {
	
	element: null,
	lastValue: null,
	
	constructor: function(element, callback){
		this.element = dojo.byId(element);
		this.callback = callback;
		this.lastValue = this.getValue();
		this.registerCallbacks(this.element);
	},
	
	onElementEvent: function(){
		var value = this.getValue();
		// FIXME: In the prototype impl, this does not appear to work for radio and checkboxes since
		// their values rarely change.	We should consider checking on the element type and firing
		// the event even if the lastValue hasn't changed for the radio button or checkbox.
		// TODO: Verify that declaring an EventObserver on a radio button does not work.	Also,
		// we should check to see if Rails does some munging to when rendering radio button so that
		// the EventObserver is checking the value based on a radio button name vs. and ID.	 If this
		// munging does occur, then this functionality appears to work as advertised.
		
		// Until we have done out TODO task, we will keep this check in to stay consistent with
		// the client-side APIs.
		if (this.lastValue != value) {
			this.callback(this.element, value);
			this.lastValue = value;
		}
	},
	
	registerListenerForField: function(element){
		var type = (element.type||"").toLowerCase();
		if (type == "") throw new Error("Invalid type for element: " + element.constructor.toString() + ".	Did you forget to specify an input type in your markup?");
	 
		var evtType;
		switch(element.type){
			case 'checkbox': // fall through
			case 'radio':
				evtType = 'onclick';
				break;
			default:
				evtType = 'onchange';
		}
		dojo.connect(element, evtType, this, "onElementEvent");
	},
	
	registerCallbacks: function(element) {
		throw new Error("[" + this.declaredClass + "] getValue is an abstract method");
	},
	
	getValue: function() {
		throw new Error("[" + this.declaredClass + "] getValue is an abstract method");
	}
});


dojo.declare("drails.Form.Element.EventObserver", [drails.EventObserver], {
	registerCallbacks: function(element){
		this.registerListenerForField(element);
	},
	
	getValue: function() {
		return dojo.fieldToObject(this.element);
	}
});


dojo.declare("drails.Form.EventObserver", [drails.EventObserver], {
	registerCallbacks: function(element){
		dojo.forEach(element.elements, function(node){
			this.registerListenerForField(node);
		}, this);
	},
	
	getValue: function() {
		return dojo.formToObject(this.element);
	}
});


dojo.declare("drails.Sortable", null, {
	options: null,
	source: null,
	sourceNode: null,
	connects: null,
	
	constructor: function(element, options){
		this.connects = [];
		this.options = options || {};
		this.sourceNode = dojo.byId(element);
		this._applyAttributes();
		this._initDnd();
	},
	
	destroy: function(){
		if (this.source){
			this.source.destroy();
			this.source = null;
		}
		if (this.connects){
			dojo.forEach(this.connects, function(connection){
				dojo.disconnect(connection);
			});
			this.connects = null;
		}
		this.options = null;
		this.sourceNode = null;
	},
	
	onUpdate: function(source, nodes, copy, target){
	},
	
	_applyAttributes: function(){
		dojo.attr(this.sourceNode, "dojoType", "dojo.dnd.Source");
		dojo.query("> *", this.sourceNode).forEach(function(node){
			dojo.addClass(node, "dojoDndItem");
		});
	},
	
	_initDnd: function(){
		this.source = new dojo.dnd.Source(this.sourceNode);
		this.connects.push(dojo.connect(this.source, "onDndDrop", this, "onUpdate"));
		if (dojo.isFunction(this.options.onUpdate)){
			this.connects.push(dojo.connect(this, "onUpdate", this.options.onUpdate));
		}
	}
});

drails.Sortable.create = function(element, options){
	dojo.require("dojo.dnd.Source");
	return new drails.Sortable(element, options);
}

//TODO: Test with date fields
drails.Sortable.serialize = function(element){
	var ret = [];
	var node = dojo.byId(element);
	dojo.query("> *", node).forEach(function(child){
		ret.push(node.id + "[]=" + child.id.split("_")[1]);
	});
	return ret.join("&");
}

dojo.declare("drails.dnd.Source", null, {
	supportedCallbacks: ['onDndSourceOver', 'onDndStart', 'onDndDrop', 'onDndCancel'],
	
	connects: null,
	source: null,
	options: null,
	
	initSource: function(node){
		dojo.require("dojo.dnd.Source");
		this.source = new dojo.dnd.Source(node);
	},
	
	destroy: function(){
		dojo.forEach(this.connects, function(c){
			dojo.disconnect(c);
		});
		this.connects = null;
		this.source.destroy();
		this.source = null;
		this.options = null;
	},
	
	applyOptions: function(options){
		this.options = options || {};
		this.applyCallbacks();
	},
	
	applyCallbacks: function(){
		this.connects = [];
		dojo.forEach(this.supportedCallbacks, function(cb){
			this.connects.push(dojo.connect(this.source, cb, this, cb));
			if (dojo.isFunction(this.options[cb])) {
				this.connects.push(dojo.connect(this, cb, this.options[cb]));
			}
		}, this);
	},
	
	// Callback hooks
	onDndSourceOver: function(){},
	onDndStart: function(){},
	onDndDrop: function(){},
	onDndCancel: function(){}
});

dojo.declare("drails.Draggable", [drails.dnd.Source], {	 
	element: null,
	sourceNode: null,
	
	constructor: function(element, options){
		this.element = dojo.byId(element);
		this.connects = [];
		
		this.sourceNode = dojo.doc.createElement("div");
		dojo.place(this.sourceNode, this.element, "before");
		this.sourceNode.appendChild(this.element);
		dojo.addClass(this.element, "dojoDndItem");
		
		this.initSource(this.sourceNode);
		this.applyOptions(options);
	}
});


dojo.declare("drails.Droppable", null, {
	container: null,
	
	constructor: function(element, options){
		this.container = new dojo.dnd.Source(element);
	}
});

