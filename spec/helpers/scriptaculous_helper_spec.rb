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
        helper_output.should == 'new drails.Effect(element,"foo",{});'
      end
      
      describe "when name is a TOGGLE_EFFECT" do
        before do
          @helper_output = test_view.visual_effect(:toggle_appear, "my_id")
        end
        it "calles .toggle on drails.Effect with ID as the first param, the effect as the second param, and options as the third param" do
          helper_output.should == "drails.Effect.toggle(\"my_id\",\"appear\",{});"
        end
      end
      
      describe "when element is passed" do
        before do
          @helper_output = test_view.visual_effect("foo", "my_id")
        end

        it "generates a JS effect constructor for the element" do
          helper_output.should == 'new drails.Effect("my_id","foo",{});'
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
          helper_output.should == "new drails.Effect(\"my_id\",\"foo\",{direction:'up', endcolor:'#0000ff', queue:{limit:100,bar:'baz'}, restorecolor:'true', scaleMode:'scale', startcolor:'#ff0000'});"
        end
      end
      
    end
  end
  
  describe "#sortable_element_js" do
    attr_reader :helper_output

    before do
      @helper_output = test_view.sortable_element_js('my_id')
    end
    
    describe "when the element is passed" do
      it "returns the drails.Sortable.create method with the default onUpdate  callback" do
        helper_output.should == 'drails.Sortable.create("my_id", {onUpdate:function(){new drails.Request(\'http://somemockurl.com\', {asynchronous:true, evalScripts:true, parameters:Sortable.serialize("my_id")})}});'
      end
    end
    
    describe "when :with is passed" do
      before do
        @helper_output = test_view.sortable_element_js('my_id', :with => "function(){}")
      end
      
      it "returns extra parameters" do
        helper_output.should == "drails.Sortable.create(\"my_id\", {onUpdate:function(){new drails.Request('http://somemockurl.com', {asynchronous:true, evalScripts:true, parameters:function(){}})}});"
      end
    end
    
    describe "when :onUpdate is passed" do
      before do
        @helper_output = test_view.sortable_element_js('my_id', :onUpdate => "function(){}")
      end
      
      it "returns a custom callback instead of a drails.Request" do
        helper_output.should == "drails.Sortable.create(\"my_id\", {onUpdate:function(){}});"
      end
    end
    
    describe "when sortable specific params are passed" do
      before do
        options = {
          :tag => "tag",
          :overlap => true,
          :constraint => "if (true)",
          :handle => "handleIt()",
          :containment => [ 'blah', 'blah2' ],
          :only => ['boo', 'boo2']
        }
        @helper_output = test_view.sortable_element_js('my_id', options)
      end
      it "returns a drails.Sortable with all of the options" do
        helper_output.should == "drails.Sortable.create(\"my_id\", {constraint:'if (true)', containment:['blah','blah2'], handle:'handleIt()', onUpdate:function(){new drails.Request('http://somemockurl.com', {asynchronous:true, evalScripts:true, parameters:Sortable.serialize(\"my_id\")})}, only:['boo','boo2'], overlap:'true', tag:'tag'});"
      end
    end
  end
  
  describe "#draggable_element_js" do
    attr_reader :helper_output

    before do
      @helper_output = test_view.draggable_element_js('my_id')
    end
    
    it "returns a new drails.Draggable" do
      helper_output.should == 'new drails.Draggable("my_id", {});'
    end
  end
  
  describe "#drop_receiving_element_js" do
    attr_reader :helper_output

    before do
      @helper_output = test_view.drop_receiving_element_js('my_id')
    end
    
    describe "when an element is passed" do
      it "returns a drails.Droppable.add call with the default drails.Request for the onDrop handler" do
        helper_output.should == "drails.Droppables.add(\"my_id\", {onDrop:function(element){new drails.Request('http://somemockurl.com', {asynchronous:true, evalScripts:true, parameters:'id=' + encodeURIComponent(element.id)})}});"
      end
    end
    
    
    describe "when :with is passed" do
      before do
        @helper_output = test_view.drop_receiving_element_js('my_id', :with => "function(){}")
      end
      
      it "returns extra parameters" do
        helper_output.should == "drails.Droppables.add(\"my_id\", {onDrop:function(element){new drails.Request('http://somemockurl.com', {asynchronous:true, evalScripts:true, parameters:function(){}})}});"
      end
    end
    
    describe "when :onDrop is passed" do
      before do
        @helper_output = test_view.drop_receiving_element_js('my_id', :onDrop => "function(){}")
      end
      
      it "returns a custom callback instead of a drails.Request" do
        helper_output.should == "drails.Droppables.add(\"my_id\", {onDrop:function(){}});"
      end
    end
    
    describe "when sortable specific params are passed" do
      before do
        options = {
          :accept => ['DraggableType1', 'DraggableType2'],
          :hoverclass => 'hoverClass',
          :confirm => 'foo == "bar"'
        }
        @helper_output = test_view.drop_receiving_element_js('my_id', options)
      end
      it "returns a drails.Sortable with all of the options" do
        helper_output.should == "drails.Droppables.add(\"my_id\", {accept:['DraggableType1','DraggableType2'], hoverclass:'hoverClass', onDrop:function(element){if (confirm('foo == \\\"bar\\\"')) { new drails.Request('http://somemockurl.com', {asynchronous:true, evalScripts:true, parameters:'id=' + encodeURIComponent(element.id)}); }}});"
      end
    end
    
  end
end