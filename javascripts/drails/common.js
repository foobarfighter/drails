dojo.provide("drails.common");

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
	interpolateXhr: function(xhrArgs) {
		for (var item in xhrArgs) {
			var cb = drails._xhrCallbackMap[item];
			if (cb) {
				this[item] = xhrArgs[item];
				dojo.connect(this, cb, this, this[item]);
			}
			else {
				this.unsupportedOperation(item)
			}
		}
	},
	
	unsupportedOperation: function(callbackName){
		throw(callbackName + " is not a supported drails operation");
	}
})

dojo.declare("drails.Updater", [drails._base, dojo._base.xhr], {
	constructor: function(target, url, xhrArgs) {
		var dojoXhrArgs;
		
		//if (target) this.interpolateTargets(target);		
		if (xhrArgs) dojoXhrArgs = this.interpolateXhr(xhrArgs);
	}
	
	// interpolateTargets: function(target) {
	// 		var successNode, failureNode;
	// 		
	// 		if (target instanceof String) {
	// 			var updateNode = target;
	// 			if (updateNode) {
	// 				dojo.connect(this, "load", this, function(response, ioArgs) { dojo.byId(updateNode).innerHTML = response });
	// 				dojo.connect(this, "failure", this, function(response, ioArgs) { dojo.byId(updateNode).innerHTML = response });
	// 			}
	// 		} else if (targets && targets instanceof Object) {
	// 			var successNode = target["success"];
	// 			var failureNode = target["failure"];
	// 			if (successNode) {
	// 				dojo.connect(this, "load", this, function(response, ioArgs) { dojo.byId(successNode).innerHTML = response });
	// 			}
	// 			if (failureNode) {
	// 				dojo.connect(this, "failure", this, function(response, ioArgs) { dojo.byId(failureNode).innerHTML = response });
	// 			}
	// 		}
	// 	}
});