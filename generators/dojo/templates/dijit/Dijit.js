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
		
		// This handler is declared in the widget
		onClickHandler: function(evt){
			alert("clicked");
			dojo.stopEvent(evt);
		},
		
		postCreate: function(){
			dojo.query("span", this.domNode).addContent("<div>Example of coercing values in postCreate</div>");
		},
		
		someMethod: function(){
			return false;
		}
	}
);