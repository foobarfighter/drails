dependencies ={
	layers:	 [
		{
			name: "<%= name %>.js",
			dependencies: [
				"drails.common",
				"drails.monkey"
				// TODO: Insert the modules that you want to include in the build.  Be sure that the module
				//       has an explicit dojo.provide or else the packaging system will not pick it up.
				//       For more information visit:
				//          http://www.dojotoolkit.org/book/dojo-book-0-9/part-4-meta-dojo/package-system-and-custom-builds
			]
		}
	],
	prefixes: [
<%= generated_prefixes && generated_prefixes.length ? generated_prefixes.collect { |pair| "\t\t" + pair }.join(",\n") : "" %>,
		//[ "dijit", "../dijit" ],		// Uncomment if you are using diji
		//[ "dojox", "../dojox" ],		// Uncomment if you are using dojox modules
		[ "drails", "../drails" ]
	]
};