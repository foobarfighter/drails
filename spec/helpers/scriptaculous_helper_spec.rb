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
    Drails::ScriptaculousOverride.override
  end

  describe "#visual_effect" do
    attr_reader :helper_output
    
    describe "when name is passed" do
      before do
        @helper_output = test_view.visual_effect("foo")
      end
      
      it "generates a JS effect constructor for the name" do
        helper_output.should == 'new drails.Effect.Foo(element,{});'
      end
      
      describe "when name is a TOGGLE_EFFECT" do
        before do
          @helper_output = test_view.visual_effect(:toggle_appear, "my_id")
        end
        it "calles .toggle on drails.Effect with ID as the first param, the effect as the second param, and options as the third param" do
          helper_output.should == "drails.Effect.toggle(\"my_id\",'appear',{});"
        end
      end
      
      describe "when element is passed" do
        before do
          @helper_output = test_view.visual_effect("foo", "my_id")
        end

        it "generates a JS effect constructor for the element" do
          helper_output.should == 'new drails.Effect.Foo("my_id",{});'
        end
      end
      
      describe "when js_options are passed" do
        before do
          options = {
            :endcolor => "#0000ff",
            :direction => "up",
            :startcolor => "#ff0000",
            :scaleMode => "scale",
            :restorecolor => true,
            :queue => { :limit => 100, :bar => "baz" }
          }
          @helper_output = test_view.visual_effect("foo", "my_id", options)
        end
        
        it "passes the hash as the effect options" do
          helper_output.should == "new drails.Effect.Foo(\"my_id\",{direction:'up', endcolor:'#0000ff', queue:{bar:'baz',limit:100}, restorecolor:'true', scaleMode:'scale', startcolor:'#ff0000'});"
        end
      end
      
    end
  end
  
  describe "#sortable_element_js" do
    attr_reader :helper_output

    before do
      @helper_output = test_view.sortable_element_js('my_id')
    end
    
    it "pending specs" do
      pending
    end
  end
  
  describe "#draggable_element_js" do
    attr_reader :helper_output

    before do
      @helper_output = test_view.draggable_element_js('my_id')
      helper_output.should_not be_blank
    end
    
    it "pending specs" do
      pending
    end
  end
  
  describe "#drop_receiving_element_js" do
    attr_reader :helper_output

    before do
      @helper_output = test_view.drop_receiving_element_js('my_id')
      helper_output.should_not be_blank
    end
    
    it "pending specs" do
      pending
    end
  end
end