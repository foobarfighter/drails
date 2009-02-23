dir = File.dirname(__FILE__)

require 'rubygems'
require 'polonium'
require dir + '/selenium_helper'

describe "drails.Updater" do
  
  attr_reader :driver
  before do
    @driver = DrailsDriver.new("http://localhost:3000/updater/show")
  end
  
  it "clicking on the test_success link should return success_js" do
    driver.click("test_success")
    driver.assert_element_present("success_js")
    driver.get_inner_html("success_js").should == "success_js"
  end
  
  it "clicking on the test_failure link should return failure_js" do
    driver.click("test_failure")
    driver.assert_element_present("failure_js")
    driver.get_inner_html("failure_js").should == "failure_js"
  end
end
