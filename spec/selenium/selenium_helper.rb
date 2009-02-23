dir = File.dirname(__FILE__)
require dir + "/../spec_helper"
require 'selenium'
require "polonium"

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
  
  def type(locator, value)
    selenium_driver.type(locator, value)
  end
end