require 'rake'
require 'spec/rake/spectask'
require 'rake/rdoctask'
require 'installer'
require 'fileutils'

DRAILS_PATH = File.dirname(__FILE__)
TESTAPP_PATH = File.join(File.dirname(__FILE__), "testapp")

desc 'Default: run specs.'
task :default => :spec

desc 'Runs the d-rails ruby specs.'
Spec::Rake::SpecTask.new(:runspec) do |t|
  t.libs << 'lib'
  t.libs << File.dirname(__FILE__)
  t.spec_files = FileList['spec/**/*_spec.rb']
end

desc 'Test the d-rails ruby specs'
task :spec  => ['testjs:teardown', 'runspec'] do
end

desc 'Generate documentation for the drails plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Drails'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

namespace :cli do
  desc 'Setup the d-rails CLI development environment.'
  task :setup => :teardown do
    cp_r ".", "/tmp/d-rails"
    rm_rf "testapp/public/javascripts/dojo"
    mkdir_p "testapp/vendor/plugins"
    cp_r "/tmp/d-rails", "testapp/vendor/plugins"
    chdir "testapp/vendor/plugins/d-rails" do
      rm_rf  "generators"
      ln_s(DRAILS_PATH + "/generators", "generators", :verbose => true)
      rm_rf  "tasks"
      ln_s(DRAILS_PATH + "/tasks", "tasks", :verbose => true)
    end
    puts "Executing d-rails install..."
    cmd = "cd #{TESTAPP_PATH}/vendor/plugins/d-rails; chmod 755 install.rb; RAILS_ROOT=#{TESTAPP_PATH} ./install.rb"
    puts cmd
    `#{cmd}`
    puts "done"
  end
  
  desc 'Tear down the d-rails CLI development environment'
  task :teardown do
    rm_rf "testapp/vendor"
    rm_rf "/tmp/d-rails"
  end
end

namespace :testjs do
  desc 'Setup the d-rails javascript development environment.'
  task :setup do
    installer = Drails::Installer.new(TESTAPP_PATH, DRAILS_PATH)
    installer.require_prerequisites!
    installer.install_dojo_source
    
    src_drails_js = File.join(DRAILS_PATH, 'javascripts', 'drails')
    dest_drails_js = File.join(TESTAPP_PATH, 'public', 'javascripts', 'dojo', 'drails')

    ln_s(src_drails_js, dest_drails_js)
  end
  
  desc 'Fire up a web browser and run the d-rails javascript tests'
  task :spec => [ :teardown, :setup ] do
    `cd testapp; script/server 2>&1 > /dev/null &`
    `open http://localhost:3000/javascripts/dojo/drails/tests/runTests.html`
  end

  desc 'Tear down the d-rails development environment.'
  task :teardown do
    delete_files = ['testapp/javascripts/public/dojo/drails'].each do |file|
      if File.exists? file
        rm file 
        puts "removed #{file}"
      end
    end
    rm_rf_dirs = ['testapp/public/javascripts/dojo'].each do |dir|
      if File.directory?(dir)
        FileUtils::rm_rf dir
        puts "removed #{dir}"
      end
    end
  end
end
