dir = File.dirname(__FILE__)
require dir + "/selenium_helper"
class SeleniumSuite
  def run
    dir = File.dirname(__FILE__)
    test_files = Dir.glob("#{dir}/**/*_spec.rb")
    test_files.each do |x|
      require File.expand_path(x)
    end

    unless Polonium::Configuration.instance.browser
      Polonium::Configuration.instance.browser = "firefox"
    end
    ::Spec::Runner::CommandLine.run
  end
end

exit SeleniumSuite.new.run