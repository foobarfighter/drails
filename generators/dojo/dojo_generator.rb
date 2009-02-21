class DojoGenerator < Rails::Generator::Base
  
  JS_PATH = "public/javascripts"
  
  attr_accessor :type, :name, :split_name
  
  def initialize(runtime_args, runtime_options = {})
    super
    @type = args.shift
    @name = args.shift
  end
  
  def manifest
    m = nil
    
    # TODO: Figure out the right way to throw errors.  There's probably a more
    # "railsy" way to do this.
    begin
      raise "TYPE and NAME must be passed as arguments" unless type && name
      @split_name = name.split(".")
    
      m = case type
      when "build": build_manifest
      when "dijit": dijit_manifest
      when "module": module_manifest
      end
    rescue Exception => e
      puts "USAGE ERROR: " + e.to_s + "\n\n"
      puts usage()
    end
    m
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
  
  def module_name(name)
    name.split(".").last
  end
  
  def module_path(name)
    p = name.split(".")
    p.pop
    "#{JS_PATH}/" + p.join("/")
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
    raise "Module TYPE must be in the format namespace.moduleName" unless split_name.length > 1
    dir = module_path(name)
    m_name = module_name(name)
    record do |m|
      m.directory dir
      m.template "module/module.js", dir + "/#{m_name}.js"
      m.directory dir + "/tests"
      m.template "module/all.js", dir + "/tests/all.js"
      m.template "module/module.html", dir + "/tests/#{m_name}.html"
      m.template "module/runTests.html", dir + "/tests/runTests.html"
      m.template "module/README", dir + "/README"
    end
  end
  
end
