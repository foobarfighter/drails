require 'rake'
require 'spec/rake/spectask'
require 'rake/rdoctask'
require 'installer'

desc 'Default: run specs.'
task :default => :test

desc 'Test the drails plugin.'
Spec::Rake::SpecTask.new(:spec) do |t|
  t.libs << 'lib'
  t.libs << File.dirname(__FILE__)
  t.spec_files = FileList['spec/**/*_spec.rb']
end

desc 'Generate documentation for the drails plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Drails'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

# Contains some utils used in this rakefile
module RakeDrails

  # FIXME: This is only safe on UNIX, and this method pretty much sucks.
  # FIXME: Could not get ln_s to work properly
  def RakeDrails.safe_ln(old, new)
    split_dir = new.split('/')
    dest = split_dir.pop();
    current_dir = pwd
    cmd = "cd #{File.join(split_dir)}; if [ ! -L #{dest} ]; then ln -s  #{File.join(current_dir, old)} #{dest}; fi; cd #{current_dir};"
    puts 'Executing: ' + cmd
    `#{cmd}`
    puts 'Done'
  end
end

DRAILS_PATH = File.dirname(__FILE__)
TESTAPP_PATH = File.join(File.dirname(__FILE__), "testapp")

namespace :testjs do
  desc 'Setup the d-rails development environment.'
  task :setup do
    installer = Drails::Installer.new(TESTAPP_PATH, DRAILS_PATH)
    installer.require_prerequisites!
    installer.install_dojo_source
    
    src_drails_js = File.join(DRAILS_PATH, 'javascripts', 'drails')
    dest_drails_js = File.join(TESTAPP_PATH, 'public', 'javascripts', 'dojo', 'drails')

    RakeDrails.safe_ln(src_drails_js, dest_drails_js)
  end

  desc 'Tear down the d-rails development environment.'
  task :teardown do
    delete_files = ['testapp/javascripts/public/dojo/drails'].each do |file|
      rm file if File.exists? file
      puts "removed #{file}"
    end
    rm_rf_dirs = ['testapp/public/javascripts/dojo'].each do |dir|
      FileUtils::rm_rf dir if File.directory?(dir)
      puts "removed #{dir}"
    end
  end
end