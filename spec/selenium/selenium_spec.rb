dir = File.dirname(__FILE__)

require 'rubygems'
require 'polonium'
require dir + '/selenium_helper'

class DrailsDriver
  include Polonium::SeleniumDsl
  delegate :select, :to => :selenium_driver
  
  def initialize(url)
    @selenium_driver = configuration.driver
    @selenium_driver.open url
  end
  
  # def method_missing(sym, args)
  #     puts "sym: #{sym.to_s}"
  #     #self.send(sym, args)
  #   end
  
  def text_present(text, options = {})
    self.assert_text_present(text, options)
  end
end


describe "Something" do
  
  attr_reader :driver
  
  before do
    @driver = DrailsDriver.new("http://localhost:3000/spec/update")
  end
  
  it "should do something" do
    driver.text_present("Google blah")
  end
end

# class SeleniumTestCase < Test::Unit::TestCase
#     include Polonium::SeleniumDsl
#     
#     delegate :select, :to => :selenium_driver
# 
#     def setup
#        super
#        @selenium_driver = configuration.driver
#     end
# 
#     def teardown
#      selenium_driver.stop if stop_driver?
#      super
#    end
# 
# end
