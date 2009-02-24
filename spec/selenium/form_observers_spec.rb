dir = File.dirname(__FILE__)

require 'rubygems'
require 'polonium'
require dir + '/selenium_helper'

describe "form observers" do
  
  attr_reader :driver
  before do
    @driver = DrailsDriver.new("http://localhost:3000/form_observers/show")
  end
  
  describe "drails.Form.Element.EventObserver" do  
    describe "when the response is successful" do
      it "posts the field data when the text changes and updates the success_response{n} div" do
        driver.type("foo_field10", "asdf")
        driver.click("tab_to10")
        driver.assert_element_present("css=#success_response10 .success_js")
        driver.get_inner_html("css=#success_response10 .success_js").should == "success_js"
      end
    end
    describe "when the response is a failure" do
      it "posts the field data when the text changes and updates the failure_response{n} div" do
        driver.type("foo_field11", "asdf")
        driver.click("tab_to11")
        driver.assert_element_present("css=#failure_response11 .failure_js")
        driver.get_inner_html("css=#failure_response11 .failure_js").should == "failure_js"
      end
    end
  end
  
  describe "drails.Form.Element.Observer" do
    describe "when the response is a failure" do
      it "posts the field data on a timeer and updates the success_response{n} div" do
        driver.assert_element_present("css=#success_response20 .success_js")
        driver.get_inner_html("css=#success_response20 .success_js").should == "success_js"
      end
    end
    describe "when the response is a failure" do
      it "posts the field data when the text changes and updates the failure_response{n} div" do
        driver.assert_element_present("css=#failure_response21 .failure_js")
        driver.get_inner_html("css=#failure_response21 .failure_js").should == "failure_js"
      end
    end
  end
  
  describe "drails.Form.EventObserver" do  
    describe "when the response is successful" do
      it "posts the field data when the text changes and updates the success_response{n} div" do
        driver.type("foo_field30", "asdf1")
        driver.type("foo_field31", "asdf2")
        driver.click("tab_to30")
        driver.assert_element_present("css=#success_response30 .success_js")
        driver.get_inner_html("css=#success_response30 .success_js").should == "success_js"
      end
    end
    
    describe "when the response is a failure" do
      it "posts the field data when the text changes and updates the failure_response{n} div" do
        driver.type("foo_field32", "asdf1")
        driver.type("foo_field33", "asdf2")
        driver.click("tab_to31")
        driver.assert_element_present("css=#failure_response31 .failure_js")
        driver.get_inner_html("css=#failure_response31 .failure_js").should == "failure_js"
      end
    end
  end
  
  describe "drails.Form.Observer" do
    describe "when the response is successful" do
      it "posts the field data when the text changes and updates the success_response{n} div" do
        driver.assert_element_present("css=#success_response40 .success_js")
        driver.get_inner_html("css=#success_response40 .success_js").should == "success_js"
      end
    end
    
    describe "when the response is a failure" do
      it "posts the field data when the text changes and updates the failure_response{n} div" do
        driver.assert_element_present("css=#failure_response41 .failure_js")
        driver.get_inner_html("css=#failure_response41 .failure_js").should == "failure_js"
      end
    end
  end
end