dojo.provide("<%= name %>.tests.module");

try{
	doh.registerUrl("<%= name %>.tests.common", dojo.moduleUrl("<%= name %>", "tests/common.html"));
}catch(e){
	doh.debug(e);
}
