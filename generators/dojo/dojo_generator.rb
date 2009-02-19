class DojoGenerator < Rails::Generator::Base
  
  JS_PATH = "public/javascripts"
  
  attr_accessor :type, :name
  
  def initialize(runtime_args, runtime_options = {})
    super
    puts 
    @type = args.shift
    @name = args.shift
  end
  
  def manifest
    case type
    when "build": build_manifest
    when "dijit": dijit_manifest
    when "module": module_manifest
    end
  end
  
  
  private
  
  def build_js_path(name)
    name ? "#{JS_PATH}/#{name}_profile.js" : "#{JS_PATH}/build_profile.js"
  end
  
  def dijit_path(name)
    dir_names = name.split(".")
    dir_names.pop
    
    "#{JS_PATH}/" + dir_names.join("/")
  end
  
  def dijit_js_path(name)
    dijit_path(name) + "/" + name.split(".").pop + ".js"
  end
  
  def dijit_test_html_path(name)
    dijit_path(name) + "/tests/" + name.split(".").pop + ".html"
  end
  
  def module_path(name)
    "#{JS_PATH}/" + name.split(".").join("/")
  end
  
  def build_manifest
    record do |m|
      m.template "profile.js", build_js_path(name)
      m.template "BUILD_README", dijit_dir + "/BUILD_README"
    end
  end
  
  def dijit_manifest
    dijit_dir = dijit_path(name)
    js_path = dijit_js_path(name)
    test_html_path = dijit_test_html_path(name)
    record do |m|
      m.directory dijit_dir
      m.template "Dijit.js", js_path
      m.directory dijit_dir + "/tests"
      m.template "Dijit.html", test_html_path
      m.template "module.js", dijit_dir + "/tests/module.js"
      m.template "runTests.html", dijit_dir + "/tests/runTests.html"
      m.template "DIJIT_README", dijit_dir + "/README"
    end
  end
  
  def module_manifest
    dir = module_path(name)
    record do |m|
      m.directory dir
      m.template "common.js", dir + "/common.js"
      m.directory dir + "/tests"
      m.template "module.js", dir + "/tests/module.js"
      m.template "common.html", dir + "/tests/common.html"
      m.template "runTests.html", dir + "/tests/runTests.html"
      m.template "MODULE_README", dir + "/README"
    end
  end
  
end
