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

describe Drails::ScriptaculousHelper do
  attr_reader :test_view
  before do
    @test_view = TestView.new
    Drails::PrototypeOverride.override
  end

  describe "#visual_effect" do
    attr_reader :helper_output

    before do
      @helper_output = test_view.periodically_call_remote
      helper_output.should_not be_blank
    end
    
    it "pending specs" do
      pending
    end
  end
  
  describe "#sortable_element_js" do
    attr_reader :helper_output

    before do
      @helper_output = test_view.periodically_call_remote
      helper_output.should_not be_blank
    end
    
    it "pending specs" do
      pending
    end
  end
  
  describe "#draggable_element_js" do
    attr_reader :helper_output

    before do
      @helper_output = test_view.periodically_call_remote
      helper_output.should_not be_blank
    end
    
    it "pending specs" do
      pending
    end
  end
  
  describe "#drop_receiving_element_js" do
    attr_reader :helper_output

    before do
      @helper_output = test_view.periodically_call_remote
      helper_output.should_not be_blank
    end
    
    it "pending specs" do
      pending
    end
  end
end