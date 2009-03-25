require 'rake'
require 'spec/rake/spectask'
require 'rake/rdoctask'
require 'installer'
require 'fileutils'

DRAILS_PATH = File.dirname(__FILE__)

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
task :spec  => ['dev:teardown:all', 'runspec'] do
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
    task :toolkit => "dev:setup:rails:testapp" do
      testapp_path = "testapps/rails-#{ENV['RAILS_VERSION']}"

      toolkit = ENV["TOOLKIT"] == "prototype" ? "prototype" : "dojo"
      puts "Setting up application using the #{toolkit} toolkit"
      File.open("#{testapp_path}/vendor/plugins/drails/config/drails.yml", "w") do |f|
        f << "drails:\n  toolkit: #{toolkit}\n"
      end
    end

    desc "Sets up drails within a testapp"
    task :full => ["dev:teardown:all", "dev:setup:rails:testapp"] do |t|
      testapp_path = File.join(DRAILS_PATH, "testapps/rails-#{ENV['RAILS_VERSION']}")

      cp_r ".", "/tmp/drails"
      mkdir_p "#{testapp_path}/vendor/plugins"
      cp_r "/tmp/drails", "#{testapp_path}/vendor/plugins"

      puts "Executing drails install..."
      cmd = "cd #{testapp_path}/vendor/plugins/drails; chmod 755 install.rb; RAILS_ROOT=#{testapp_path} ./install.rb"
      puts cmd
      `#{cmd}`
      puts "done"
      Rake::Task["dev:setup:toolkit"].invoke
    end

    desc "Sets up drails within testapp with symlinks to important source files so that development can be done while testapp is running"
    task :linked => :full  do
      testapp_path = "testapps/rails-#{ENV['RAILS_VERSION']}"

      chdir "#{testapp_path}/vendor/plugins/drails" do
        rm_rf  "generators"
        ln_s(DRAILS_PATH + "/generators", "generators", :verbose => true)
        rm_rf  "tasks"
        ln_s(DRAILS_PATH + "/tasks", "tasks", :verbose => true)
      end
      rm_rf "#{testapp_path}/public/javascripts/dojo/drails"
      ln_s(DRAILS_PATH + "/javascripts/drails", "#{File.join(DRAILS_PATH, testapp_path)}/public/javascripts/dojo/drails")
    end

    namespace :rails do
      desc "Finds the versions of the installed rails gems on your system"
      task :find_versions do
        @rails_versions = nil
        `gem list rails`.split("\n").each do |line|
          if line =~ /^rails\s+\((.*?)\)/
            @rails_versions = $1.split(/,\s*/)
          end
        end
        puts "Found rails versions: #{@rails_versions.join(', ')}"
      end

      task :validate_args => :find_versions do
        raise "A RAILS_VERSION number was expected" unless ENV["RAILS_VERSION"]
        unless File.directory?("testapps/generate/rails-#{ENV['RAILS_VERSION']}")
          warn "RAILS_VERSION (#{ENV['RAILS_VERSION']}) is not an officially supported version, but drails may still work"
        end
        unless @rails_versions && @rails_versions.find { |v| v == ENV['RAILS_VERSION'] }
          raise "RAILS_VERSION (#{ENV['RAILS_VERSION']}) was not found in your installed rails versions"
        end
      end

      desc "Sets up a rails testapp with files layered in from the generate directory"
      task :testapp => [ :validate_args, "dev:teardown:rails" ] do
        app_generate_command = "rails _#{ENV['RAILS_VERSION']}_ rails-#{ENV['RAILS_VERSION']}"
        Dir.chdir "testapps" do
          puts "Execing: #{app_generate_command}"
          system app_generate_command
        end

        Rake::Task["dev:setup:rails:layer_shared"].invoke
        Rake::Task["dev:setup:rails:layer_version_specific"].invoke
      end

      task :layer_shared => :testapp do
        cp_r Dir["testapps/generate/shared/*"], "testapps/rails-#{ENV['RAILS_VERSION']}"
      end

      task :layer_version_specific => :testapp do
        if File.directory?("testapps/generate/rails-#{ENV['RAILS_VERSION']}")
          cp_r Dir["testapps/generate/rails-#{ENV['RAILS_VERSION']}/*"], "testapps/rails-#{ENV['RAILS_VERSION']}"
        end
      end
    end
  end

  namespace :teardown do
    desc "Tears down the entire development environment"
    task :all => [ :rails ] do
      rm_rf "/tmp/drails"
    end

    desc "Cleans previously generated testapps"
    task :rails do
      rm_rf Dir["testapps/rails-*"]
    end
  end
end

namespace :server do
  desc "Starts the server"
  task :start => [:stop, "dev:setup:rails:testapp"] do
    testapp_path = "testapps/rails-#{ENV['RAILS_VERSION']}"

    rails_env = ENV['RAILS_ENV'] || 'development'
    puts "starting #{rails_env} server"
    puts "cd #{testapp_path}; script/server -e #{rails_env} -d > /dev/null"
    `cd #{testapp_path}; script/server -e #{rails_env} -d > /dev/null`
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

namespace :testjs do
  desc 'Fire up a web browser and run the drails javascript tests'
  task :spec => [ "dev:setup:linked", "server:restart" ] do
    `open http://localhost:3000/javascripts/dojo/drails/tests/runTests.html`
  end
end

namespace :selenium do
  desc "Runs Selenium tests"
  task :spec => ["dev:setup:linked", "server:start"] do
    system("RAILS_ENV=development ruby -Ilib -e 'require \"spec/selenium/selenium_suite\"'")
  end
end
