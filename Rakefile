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

namespace :dev do
  namespace :setup do
    task :toolkit do
      toolkit = ENV["TOOLKIT"] == "prototype" ? "prototype" : "dojo"
      puts "Setting up application using the #{toolkit} toolkit"
      File.open("testapp/vendor/plugins/d-rails/config/drails.yml", "w") do |f|
        f << "drails:\n  toolkit: #{toolkit}\n"
      end
    end
    
    task :full => ["dev:teardown:all"] do |t|
      cp_r ".", "/tmp/d-rails"
      rm_rf "testapp/public/javascripts/dojo"
      mkdir_p "testapp/vendor/plugins"
      cp_r "/tmp/d-rails", "testapp/vendor/plugins"
      
      puts "Executing d-rails install..."
      cmd = "cd #{TESTAPP_PATH}/vendor/plugins/d-rails; chmod 755 install.rb; RAILS_ROOT=#{TESTAPP_PATH} ./install.rb"
      puts cmd
      `#{cmd}`
      puts "done"
      Rake::Task["dev:setup:toolkit"].invoke
    end
    
    task :linked => :full  do
      chdir "testapp/vendor/plugins/d-rails" do
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
    task :all => [ :dojo ] do
      rm_rf "testapp/vendor"
      rm_rf "/tmp/d-rails"
    end
    
    task :dojo do
      rm_rf "testapp/public/javascripts/dojo"
    end
  end
end

namespace :server do
  desc "Starts the server"
  task :start => :stop do
    puts "starting server"
    `cd testapp; script/server -d > /dev/null`
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
  desc 'Setup the d-rails CLI development environment.'
  task :setup => [ "dev:setup:linked" ] do
  end
  
  desc 'Tear down the d-rails CLI development environment'
  task :teardown => ["dev:teardown:all"] do
  end
end

namespace :testjs do
  desc 'Setup the d-rails javascript development environment.'
  task :setup => ["dev:setup:linked"] do
  end
  
  desc 'Fire up a web browser and run the d-rails javascript tests'
  task :spec => [ :teardown, :setup, "server:restart" ] do
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

namespace :selenium do
  desc "Sets up the selenium test environment"
  task :setup => "dev:setup:linked" do
  end
  
  desc "Runs Selenium tests"
  task :spec => [:setup, "server:start"] do
    system("ruby -Ilib -e 'require \"spec/selenium/selenium_suite\"'")
  end
end
