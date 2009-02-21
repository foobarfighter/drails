dojo.provide("<%= name %>");
dojo.require("dijit.dijit");

dojo.require("dijit._Widget");
dojo.require("dijit._Templated");

dojo.declare("<%= name %>",
	[dijit._Widget, dijit._Templated],
	{
		templatePath: dojo.moduleUrl("<%= module_prefix %>", "templates/<%= module_name %>.html"),
		
		constructor: function(){
		
		},
		
		someMethod: function(){
			return false;
		}
	}
);