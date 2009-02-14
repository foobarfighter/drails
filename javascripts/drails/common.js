dojo.provide("drails.common");
dojo.require("drails.monkey");

drails._insertionMap = {
  "top":     "first",
  "bottom":  "last",
  "before":  "before",
  "after":   "after"
};

drails._xhrMap = {
  "asynchronous": [ "sync", function(v) { return !v; } ],
  "method":       [ "method", function(v) { return v.toLowerCase(); } ],
  "insertion":    [ "place", function(v) { return drails._insertionMap[v] }],
  "parameters":   [ "content", function(v) { return dojo.queryToObject(v); } ],
  "evalScripts":  [ "noop", function(v) { return null; } ]
};

drails._xhrCallbackMap = {
  "onUninitialized":  null,
  "onLoading":        null,
  "onLoaded":         null,
  "onInteractive":    null,
  "onComplete":       null,   // handle ?
  "onFailure":        "error",
  "onSuccess":        "load"
  // TODO 100..599
};

dojo.declare("drails._base", null, {
  transformCallbacks: function(url, xhrArgs) {
    var dojoXhrArgs = { url: url };
    for (var protoCallback in xhrArgs) {
      var dojoCallback = drails._xhrCallbackMap[protoCallback];
      if (dojoCallback) {   // Found callback mapping
        // If a prototype callback handler exists on this object
        if (this[protoCallback]) {
          dojo.connect(dojoXhrArgs, dojoCallback, this, protoCallback);
          if (xhrArgs[protoCallback]){
            dojo.connect(this, protoCallback, xhrArgs[protoCallback]);  // Connect the callback to the currently existing callback
          }
        } else if (xhrArgs[protoCallback]) {
          dojoXhrArgs[dojoCallback] = xhrArgs[protoCallback];
        }
      } else {              // Did not find a callback mapping
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
    // (Prototype apparently does this).  Am I missing something?
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
    if (this.lastValue != value) {
      this.callback(this.element, value);
      this.lastValue = value;
    }
  },
  
  registerCallbacks: function() {
    throw new Error("[" + this.declaredClass + "] getValue is an abstract method");
  },
  
  getValue: function() {
    throw new Error("[" + this.declaredClass + "] getValue is an abstract method");
  }
});


dojo.declare("drails.Form.Element.EventObserver", [drails.EventObserver], {
  registerCallbacks: function(element){
  },
  
  getValue: function() {
    //return Form.Element.getValue(this.element);
  }
});

dojo.declare("drails.Form.Element.EventObserver", [drails.EventObserver], {
  registerCallbacks: function(element){
  },
  
  getValue: function() {
    //return Form.Element.getValue(this.element);
  }
});

dojo.declare("drails.Form.EventObserver", [drails.EventObserver], {
  registerCallbacks: function(element){
    
  },
  
  getValue: function() {
    //return Form.serialize(this.element);
  }
});








