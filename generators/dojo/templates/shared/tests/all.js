dojo.provide("<%= module_prefix %>.tests.all");

try{
	doh.registerUrl("<%= module_prefix %>.tests.<%= module_name %>", dojo.moduleUrl("<%= module_prefix %>", "tests/test_<%= module_name %>.html"));
}catch(e){
	doh.debug(e);
}
