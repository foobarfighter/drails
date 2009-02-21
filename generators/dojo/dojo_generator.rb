class DojoGenerator < Rails::Generator::Base
  
  JS_PATH = "public/javascripts"
  
  # Shared instance vars
  attr_accessor :type, :name
  
  # Build instance vars
  attr_accessor :generated_prefixes, :build_file
  
  # Module instance vars
  attr_accessor :split_name, :module_name, :module_namespace, :module_prefix, :module_public_dir, :module_rails_dir, :module_js_rails_path
  
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
      
      m = case type
      when "build": build_manifest
      when "dijit": module_manifest
      when "module": module_manifest
      end
    rescue Exception => e
      puts "USAGE ERROR: " + e.to_s + "\n\n"
      puts usage()
    end
    m
  end
  
  
  private
  
  def setup_instance_vars
    tmp_module_array = name.split(".")
    @split_name = Array.new(tmp_module_array)
  	@module_name = tmp_module_array.pop
  	@module_namespace = tmp_module_array.first
  	@module_prefix = tmp_module_array.join(".")
  	@module_public_dir = tmp_module_array.split('.').join('/')
  	@module_rails_dir = "#{JS_PATH}/#{module_public_dir}"
  	@module_js_rails_path = "#{module_rails_dir}/#{module_name}.js"
  end
  
  def setup_build_instance_vars
    @build_file = "#{name}.profile.js"
    setup_generated_prefixes
  end
  
  def setup_generated_prefixes
    js_dirs = Dir["#{RAILS_ROOT}/public/javascripts/*"].select { |f| File.directory?(f) }
    modules = js_dirs.select { |d| dirname = d.split("/").pop; dirname != "dojo" && dirname != "." && dirname != ".." }
    if modules
      @generated_prefixes = modules.collect { |dir|
        dirname = dir.split("/").pop
        "[ '#{dirname}', '../../#{dirname}' ]"
      }
    end
  end
  
  def build_manifest
    setup_build_instance_vars
    
    record do |m|
      m.template "build/profile.js", "#{JS_PATH}/#{build_file}"
      m.template "build/README", "#{JS_PATH}/README"
    end
  end
  
  def module_manifest
    setup_instance_vars
    
    raise "Module TYPE must be in the format namespace.module" unless split_name.length > 1
    case type
    when "module":
      source_js = "module/module.js"
      source_test_html = "module/tests/test_module.html"
      source_readme = "module/README"
    when "dijit":
      source_js = "dijit/Dijit.js"
      source_test_html = "dijit/tests/test_Dijit.html"
      source_readme = "dijit/README"
    end
    record do |m|
      m.directory module_rails_dir
      m.template source_js, module_js_rails_path
      if type == "dijit"
        m.directory "#{module_rails_dir}/templates"
        m.template "dijit/templates/Dijit.html", "#{module_rails_dir}/templates/#{module_name}.html"
      end
      m.directory "#{module_rails_dir}/tests"
      m.template "shared/tests/all.js", "#{module_rails_dir}/tests/all.js"
      m.template source_test_html, "#{module_rails_dir}/tests/test_#{module_name}.html"
      m.template "shared/tests/runTests.html", "#{module_rails_dir}/tests/runTests.html"
      m.template source_readme, "#{module_rails_dir}/README"
    end
  end
  
end
