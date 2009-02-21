<%
	m_array = name.split(".")
	module_name = m_array.pop
	module_prefix = m_array.join(".")
%>

dojo.provide("<%= module_prefix %>.tests.all");

try{
	doh.registerUrl("<%= module_prefix %>.tests.<%= module_name %>", dojo.moduleUrl("<%= module_prefix %>", "tests/<%= module_name %>.html"));
}catch(e){
	doh.debug(e);
}
