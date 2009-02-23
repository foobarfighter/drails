####################################################################
#                                                                  #
#      Copyright (c) 2008, Bob Remeika and others                  #
#      All Rights Reserved.                                        #
#                                                                  #
#      Licensed under the MIT License.                             #
#      For more information on d-rails licensing, see:             #
#                                                                  #
#          http://www.opensource.org/licenses/mit-license.php      #
#                                                                  #
####################################################################

require File.join(File.dirname(__FILE__), "../spec_helper.rb")

describe Drails::PrototypeHelper do
  attr_reader :test_view
  before do
    @test_view = TestView.new
    Drails::PrototypeOverride.override
  end

  describe "#periodically_call_remote_with_dojo" do
    attr_reader :helper_output

    before do
      @helper_output = test_view.periodically_call_remote
    end
    
    it "generates a drails.PeriodicalExecuter" do
      helper_output.should == "<script type=\"text/javascript\">\n//<![CDATA[\nnew drails.PeriodicalExecuter(function() {new drails.Request('http://somemockurl.com', {asynchronous:true, evalScripts:true})}, 10)\n//]]>\n</script>"
    end

  end

  describe "#remote_function" do
    attr_reader :helper_output
    
    describe "when an empty object is passed" do
      before do
        @helper_output = test_view.remote_function({})
      end
      
      it "returns the basic drails.Request call" do
        helper_output.should == "new drails.Request('http://somemockurl.com', {asynchronous:true, evalScripts:true})"
      end
    end
    
    describe "when :update is passed" do
      before do
        @helper_output = test_view.remote_function({ :update => "some_div" })
      end
      
      it "returns the drails.Updater with 'some_div' as it's target" do
        helper_output.should == "new drails.Updater('some_div', 'http://somemockurl.com', {asynchronous:true, evalScripts:true})"
      end
    end
    
    describe "when :update is passed as a hash" do
      before do
        @helper_output = test_view.remote_function({ :update => { :success => 'success_div', :failure => 'failure_div' } })
      end
      
      it "return the drails.Updater with the 'success_div' and the 'failure_div'" do
        helper_output.should == "new drails.Updater({success:'success_div',failure:'failure_div'}, 'http://somemockurl.com', {asynchronous:true, evalScripts:true})"
      end
    end
    
    describe "when :position is passed" do
      before do
        @helper_output = test_view.remote_function( :update => "some_div", :position => :top )
      end
      it "returns the drails.Updater with an 'insertion' option" do
        helper_output.should == "new drails.Updater('some_div', 'http://somemockurl.com', {asynchronous:true, evalScripts:true, insertion:'top'})"
      end
    end
    
    describe "when callbacks are passed" do
      before do
        @helper_output = test_view.remote_function( :success => "function(){alert('complete')}" )
      end
      
      it "return the drails.Request with the callback" do
        helper_output.should == "new drails.Request('http://somemockurl.com', {asynchronous:true, evalScripts:true, onSuccess:function(request){function(){alert('complete')}}})"
      end
    end
    
    describe "when a browser-side condition is passed" do
      before do
        @helper_output = test_view.remote_function( :condition => "x == y" )
      end
      
      it "return the drails.Request wrapped in a condition" do
        helper_output.should == "if (x == y) { new drails.Request('http://somemockurl.com', {asynchronous:true, evalScripts:true}); }"
      end
    end
    
    describe "when :with is passed" do
      before do
        @helper_output = test_view.remote_function( :with => "'baz=bang'" )
      end
      
      it "return the drails.Request with additional parameters" do
        helper_output.should == "new drails.Request('http://somemockurl.com', {asynchronous:true, evalScripts:true, parameters:'baz=bang'})"
      end
    end
    
    describe "when :before is passed" do
      before do
        @helper_output = test_view.remote_function( :before => "alert('test')" )
      end
      
      it "return the drails.Request with a client-side statement preceding the request" do
        helper_output.should == "alert('test'); new drails.Request('http://somemockurl.com', {asynchronous:true, evalScripts:true})"
      end
    end
    
    describe "when :after is passed" do
      before do
        @helper_output = test_view.remote_function( :after => "alert('test')" )
      end
      
      it "return the drails.Request with a client-side statement following the request" do
        helper_output.should == "new drails.Request('http://somemockurl.com', {asynchronous:true, evalScripts:true}); alert('test')"
      end
    end
  end
  
  describe "#submit_to_remote" do
    attr_reader :helper_output
    before do
      @helper_output = test_view.submit_to_remote( 'my_name', 'my_value' )
    end
    
    it "returns a form submit" do
      helper_output.should == "<input name=\"my_name\" onclick=\"new drails.Request('http://somemockurl.com', {asynchronous:true, evalScripts:true, parameters:dojo.formToQuery(this.form)});\" type=\"button\" value=\"my_value\" />"
    end
  end
  
  describe "#observe_field" do
    attr_reader :helper_output
    
    describe "when the default parameters are passed" do
      before do
        @helper_output = test_view.observe_field("some_field")
      end
      
      it "returns a drails.Form.Element.EventObserver" do
        helper_output.should == "<script type=\"text/javascript\">\n//<![CDATA[\nnew drails.Form.Element.EventObserver('some_field', function(element, value) {new drails.Request('http://somemockurl.com', {asynchronous:true, evalScripts:true, parameters:value})})\n//]]>\n</script>"
      end
    end
    
    describe "when frequency is passed" do
      before do
        @helper_output = test_view.observe_field("some_field", :frequency => 100)
      end
      
      it "returns a drails.Event" do
        helper_output.should == "<script type=\"text/javascript\">\n//<![CDATA[\nnew drails.Form.Element.Observer('some_field', 100, function(element, value) {new drails.Request('http://somemockurl.com', {asynchronous:true, evalScripts:true, parameters:value})})\n//]]>\n</script>"
      end
    end
  end
  
  describe "#observe_form" do
    attr_reader :helper_output
    
    describe "when the default parameters are passed" do
      before do
        @helper_output = test_view.observe_form("some_form")
      end
      
      it "returns a drails.Form.EventObserver" do
        helper_output.should == "<script type=\"text/javascript\">\n//<![CDATA[\nnew drails.Form.EventObserver('some_form', function(element, value) {new drails.Request('http://somemockurl.com', {asynchronous:true, evalScripts:true, parameters:value})})\n//]]>\n</script>"
      end
    end
    
    describe "when frequency is passed" do
      before do
        @helper_output = test_view.observe_form("some_form", :frequency => 100)
      end
      
      it "returns a drails.Event" do
        helper_output.should == "<script type=\"text/javascript\">\n//<![CDATA[\nnew drails.Form.Observer('some_form', 100, function(element, value) {new drails.Request('http://somemockurl.com', {asynchronous:true, evalScripts:true, parameters:value})})\n//]]>\n</script>"
      end
    end
  end

  describe "#options_for_ajax" do
    attr_reader :default_options
    before do
      @default_options = {
        'asynchronous' => true,
        'evalScripts' => true
      }
    end

    describe "when supported callbacks are passed" do
      it "returns the callbacks as part of the ajax options" do
        expected_options = default_options.merge(
          "onComplete" => "function(request){alert('complete')}",
          "onSuccess" => "function(request){alert('success')}",
          "onFailure" => "function(request){alert('failure')}"
          )
        params = { :success => "alert('success')", :complete => "alert('complete')", :failure => "alert('failure')" }
        actual_options = test_view.send(:options_for_ajax, params)
        dirty_json_decode(actual_options).should include_options(expected_options)
      end
    end
    
    describe "when :form is passed" do
      it "returns a dojo function for form serialization in 'parameters'" do
        expected_options = default_options.merge(
          "parameters" => "dojo.formToQuery(this)"
          )
        params = { :form => true }
        actual_options = test_view.send(:options_for_ajax, params)
        dirty_json_decode(actual_options).should include_options(expected_options)
      end
    end
    
    describe "when :submit is passed" do
      it "returns a dojo function for form serialization in 'parameters'" do
        expected_options = default_options.merge(
          "parameters" => "dojo.formToQuery('myForm')"
          )
        params = { :submit => 'myForm' }
        actual_options = test_view.send(:options_for_ajax, params)
        dirty_json_decode(actual_options).should include_options(expected_options)
      end
    end
    
    describe "when protect_against_forgery? is true" do
      before do
        mock(test_view).protect_against_forgery? { true }
        mock(test_view).form_authenticity_token { "my_token" }
      end
      
      it "returns a dojo function for form serialization in 'parameters'" do
        expected_options = default_options.merge(
          "parameters" => "'my_request_forgery_protection_token=' + encodeURIComponent('my_token')"
          )
        actual_options = test_view.send(:options_for_ajax, {})
        dirty_json_decode(actual_options).should include_options(expected_options)
      end
    end
  end

end