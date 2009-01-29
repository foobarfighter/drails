require 'rake'
require 'spec/rake/spectask'
require 'rake/rdoctask'

desc 'Default: run specs.'
task :default => :test

desc 'Test the drails plugin.'
Spec::Rake::SpecTask.new(:spec) do |t|
  t.libs << 'lib'
  t.libs << File.dirname(__FILE__)
  t.spec_files = FileList['spec/**/*_spec.rb']
end

#Rake::TestTask.new(:test) do |t|
#  t.libs << 'lib'
#  t.libs << 'test'
#  t.pattern = 'test/**/*_test.rb'
#  t.verbose = true
#end

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


namespace :dev do
  desc 'Setup the d-rails development environment.'
  task :setup do
    RakeDrails.safe_ln(DRAILS_PATH, 'testapp/vendor/plugins/drails')
    RakeDrails.safe_ln(RAILS_PATH, 'testapp/vendor/rails')

    # Install dojo source from dojo-pkg
    require 'dojo-pkg'
    puts "**  Installing dojo source into your application..."
    begin
      cmd = Dojo::Commands::Dojofy.new
      Dir.chdir(TESTAPP_PATH) do
        cmd.install
      end
    rescue Dojo::Errors::DojofyError => e
      warn "**  Dojo was not reinstalled.  Most likely you already dojofied this app."
    end

    # Temporary while working with jmole to figure out why these files are here instead of in drails.common
    src_drails_js = File.join(DRAILS_PATH, 'javascripts', 'drails')
    dest_drails_js = File.join(TESTAPP_PATH, 'public', 'javascripts', 'dojo', 'drails')

    RakeDrails.safe_ln(src_drails_js, dest_drails_js)
  end

  desc 'Tear down the d-rails development environment.'
  task :teardown do
    delete_files = ['testapp/javascripts/public/dojo/drails', 'testapp/vendor/plugins/drails', 'testapp/vendor/rails'].each do |file|
      rm file if File.exists? file
    end
    FileUtils::rm_rf 'testapp/public/javascripts/dojo' if File.exists? "testapp/public/javascripts/dojo"
  end
end