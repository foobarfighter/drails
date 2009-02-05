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

class TestView
  include ActionView::Helpers::PrototypeHelper
  include ActionView::Helpers::JavaScriptHelper

  def url_for(params)
    return "http://somemockurl.com"
  end

  def protect_against_forgery?
    false
  end
end

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
      helper_output.should_not be_blank
    end

  end

  describe "#remote_function" do
    before do
      @helper_output = test_view.remote_function
      helper_output.should_not be_blank
    end
  end

  describe "#build_callbacks" do
    attr_reader :callbacks

    describe "when :complete is passed as an option" do
      before do
        @callbacks = test_view.send(:build_callbacks, :complete => "alert('complete')")
      end
      it "adds a 'handle' callback with JavaScript code" do
        callbacks['handle'].should == "function(request){alert('complete')}"
      end
    end

    describe "when :success is passed as an option" do
      before do
        @callbacks = test_view.send(:build_callbacks, :success => "alert('success')")
      end
      it "adds a :success callback with JavaScript code" do
        callbacks['load'].should == "function(request){alert('success')}"
      end
    end

    describe "when :failure is passed as an option" do
      before do
        @callbacks = test_view.send(:build_callbacks, :failure => "alert('failure')")
      end
      it "adds a :failure callback with JavaScript code" do
        callbacks['error'].should == "function(request){alert('failure')}"
      end
    end

    describe "when an unsupported callback is passed as an option" do
      it "raises a Drails::IncompatibilityError" do
        lambda do
          test_view.send(:build_callbacks, :loaded => "alert('loaded')")
        end.should raise_error(Drails::IncompatibilityError)
      end
    end
  end

  describe "#options_for_ajax" do
    attr_reader :base_options
    before do
      @base_options = {
        'asynchronous' => true,
        'evalScripts' => true,
        'content' => "dojo.queryToObject()"
      }
    end

    describe "when callbacks are passed" do
      it "returns the callbacks as part of the ajax options" do
        expected_options = base_options.merge("load" => "function(request){alert('test')}")
        params = { :success => "alert('test')" }
        actual_options = test_view.send(:options_for_ajax, params)
        dirty_json_decoder(actual_options).should include_options(expected_options)
      end
    end
  end

end