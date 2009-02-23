dir = File.dirname(__FILE__)

require 'rubygems'
require 'polonium'
require dir + '/selenium_helper'

describe "form observers" do
  attr_reader :driver
  before do
    @driver = DrailsDriver.new("http://localhost:3000/form_observers/show")
  end
  it "does something" do
    driver.type("foo_field", "asdf")
    driver.click("tab_to")
    driver.assert_element_present("success_js")
    driver.get_inner_html("success_js").should == "success_js"
  end
end