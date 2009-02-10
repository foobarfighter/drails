require File.join(File.dirname(__FILE__), "../spec_helper.rb")

describe Drails::ScriptaculousOverride do
  describe ".override" do

    it "overrides ActionView::Helpers::ScriptaculousHelper.visual_effect" do
      test_alias_method_chained(::ActionView::Helpers::ScriptaculousHelper, :visual_effect, :dojo) do
        Drails::ScriptaculousOverride.override
      end.should be_true
    end
    
    it "overrides ActionView::Helpers::ScriptaculousHelper.sortable_element_js" do
      test_alias_method_chained(::ActionView::Helpers::ScriptaculousHelper, :sortable_element_js, :dojo) do
        Drails::ScriptaculousOverride.override
      end.should be_true
    end
    
    it "overrides ActionView::Helpers::ScriptaculousHelper.draggable_element_js" do
      test_alias_method_chained(::ActionView::Helpers::ScriptaculousHelper, :draggable_element_js, :dojo) do
        Drails::ScriptaculousOverride.override
      end.should be_true
    end
    
    it "overrides ActionView::Helpers::ScriptaculousHelper.drop_receiving_element_js" do
      test_alias_method_chained(::ActionView::Helpers::ScriptaculousHelper, :drop_receiving_element_js, :dojo) do
        Drails::ScriptaculousOverride.override
      end.should be_true
    end
    
  end
end