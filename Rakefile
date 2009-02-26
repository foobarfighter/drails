require 'rake'
require 'spec/rake/spectask'
require 'rake/rdoctask'
require 'installer'
require 'fileutils'

DRAILS_PATH = File.dirname(__FILE__)
TESTAPP_PATH = File.join(File.dirname(__FILE__), "testapp")

desc 'Default: run specs.'
task :default => :spec

desc 'Runs the drails ruby specs.'
Spec::Rake::SpecTask.new(:runspec) do |t|
  t.libs << 'lib'
  t.libs << File.dirname(__FILE__)
  t.spec_files = []
  t.spec_files += FileList['spec/helpers/*_spec.rb']
  t.spec_files += FileList['spec/*_spec.rb']
end

desc 'Test the drails ruby specs'
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

namespace :dev do
  namespace :setup do
    desc "Sets up the toolkit that will be used by the installed drails version.  Pass TOOLKIT=prototype on the command line to setup drails with the prototype tookkit."
    task :toolkit do
      toolkit = ENV["TOOLKIT"] == "prototype" ? "prototype" : "dojo"
      puts "Setting up application using the #{toolkit} toolkit"
      File.open("testapp/vendor/plugins/drails/config/drails.yml", "w") do |f|
        f << "drails:\n  toolkit: #{toolkit}\n"
      end
    end
    
    desc "Sets up drails within testapp"
    task :full => ["dev:teardown:all"] do |t|
      cp_r ".", "/tmp/drails"
      rm_rf "testapp/public/javascripts/dojo"
      mkdir_p "testapp/vendor/plugins"
      cp_r "/tmp/drails", "testapp/vendor/plugins"
      
      puts "Executing drails install..."
      cmd = "cd #{TESTAPP_PATH}/vendor/plugins/drails; chmod 755 install.rb; RAILS_ROOT=#{TESTAPP_PATH} ./install.rb"
      puts cmd
      `#{cmd}`
      puts "done"
      Rake::Task["dev:setup:toolkit"].invoke
    end
    
    desc "Sets up drails within testapp with symlinks to important source files so that development can be done while testapp is running"
    task :linked => :full  do
      chdir "testapp/vendor/plugins/drails" do
        rm_rf  "generators"
        ln_s(DRAILS_PATH + "/generators", "generators", :verbose => true)
        rm_rf  "tasks"
        ln_s(DRAILS_PATH + "/tasks", "tasks", :verbose => true)
      end
      rm_rf "testapp/public/javascripts/dojo/drails"
      ln_s(DRAILS_PATH + "/javascripts/drails", "testapp/public/javascripts/dojo/drails")
    end
  end
  
  namespace :teardown do
    desc "Tears down the entire development environment"
    task :all => [ :dojo ] do
      rm_rf "testapp/vendor"
      rm_rf "/tmp/drails"
    end
    
    desc "Removes dojo from the development environment"
    task :dojo do
      rm_rf "testapp/public/javascripts/dojo"
    end
  end
end

namespace :server do
  desc "Starts the server"
  task :start => :stop do
    rails_env = ENV['RAILS_ENV'] || 'development'
    puts "starting #{rails_env} server"
    `cd testapp; script/server -e #{rails_env} -d > /dev/null`
  end
  
  desc "Restarts the server"
  task :restart => [ :stop, :start ] do
  end
  
  desc "Stops the server"
  task :stop do
    puts "stopping server"
    `ps aux | grep "p 3000" | grep -v grep | awk '{ print $2 }' | xargs kill`
  end
end


namespace :cli do
  desc 'Setup the drails CLI development environment.'
  task :setup => [ "dev:setup:linked" ] do
  end
  
  desc 'Tear down the drails CLI development environment'
  task :teardown => ["dev:teardown:all"] do
  end
end

namespace :testjs do
  desc 'Setup the drails javascript development environment.'
  task :setup => ["dev:setup:linked"] do
  end
  
  desc 'Fire up a web browser and run the drails javascript tests'
  task :spec => [ :teardown, :setup, "server:restart" ] do
    `open http://localhost:3000/javascripts/dojo/drails/tests/runTests.html`
  end

  desc 'Tear down the drails development environment.'
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

namespace :selenium do
  desc "Sets up the selenium test environment"
  task :setup => "dev:setup:linked" do
  end
  
  desc "Runs Selenium tests"
  task :spec => [:setup, "server:start"] do
    system("ruby -Ilib -e 'require \"spec/selenium/selenium_suite\"'")
  end
end
