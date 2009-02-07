dojo.provide("drails.common");
dojo.require("dojo._base.xhr");

drails._xhrMap = {
	"before": 			null,
	"after": 				null,
	"condition": 		null,
	"asynchronous": null,
	"method": 			null,
	"insertion": 		null,
	"position": 		null,
	"form": 				null,
	"with": 				null,
	"update": 			null,
	"script": 			null,
	"type": 				null
};

drails._xhrCallbackMap = {
	"onUninitialized": 	null,
	"onLoading": 				null,
	"onLoaded": 				null,
	"onInteractive": 		null,
	"onComplete": 			null,
	"onFailure": 				"error",
	"onSuccess": 				"load"
	// TODO 100..599
};

dojo.declare("drails._base", null, {
	interpolateXhr: function(url, xhrArgs) {
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
				}	else if (xhrArgs[protoCallback]) {
				  dojoXhrArgs[dojoCallback] = xhrArgs[protoCallback];
				}
			}	else {							// Did not find a callback mapping
				this.unsupportedOperation(protoCallback);
			}
		}
		return dojoXhrArgs;
	},
	
	unsupportedOperation: function(callbackName){
		throw(callbackName + " is not a supported drails operation");
	}
})

dojo.declare("drails.Updater", [drails._base], {
  
  _successNode: null,
  _failureNode: null,
  
	constructor: function(target, url, xhrArgs) {
		var dojoXhrArgs;
		
		xhrArgs = xhrArgs || {};
		xhrArgs['onSuccess'] = xhrArgs['onSuccess'] || function() {};
		xhrArgs['onFailure'] = xhrArgs['onFailure'] || function() {};
		
		if (target) this.interpolateTargets(target);		
		if (xhrArgs) dojoXhrArgs = this.interpolateXhr(url, xhrArgs);
		dojo.xhrGet(dojoXhrArgs);
	},
	
  onSuccess: function(response, ioArgs) {
    if (this._successNode){
      dojo.byId(this._successNode).innerHTML = response.toString();
    }
  },
  
  onFailure: function(response, ioArgs) {
    if (this._failureNode){
      dojo.byId(this._failureNode).innerHTML = response.toString();
    }
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
  }
  
});