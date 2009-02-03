require File.join(File.dirname(__FILE__), "../spec_helper.rb")

class TestView
  include ActionView::Helpers::PrototypeHelper
end

describe Drails::PrototypeOverride do
  describe ".override" do

    it "overrides ActionView::Helpers::PrototypeHelper.periodically_call_remote" do
      test_alias_method_chained(::ActionView::Helpers::PrototypeHelper, :periodically_call_remote, :dojo) do
        Drails::PrototypeOverride.override
      end.should be_true

    end

    it "overrides ActionView::Helpers::PrototypeHelper.remote_function" do
      test_alias_method_chained(::ActionView::Helpers::PrototypeHelper, :remote_function, :dojo) do
        Drails::PrototypeOverride.override
      end.should be_true
    end

    it "overrides ActionView::Helpers::PrototypeHelper.build_callbacks" do
      test_alias_method_chained(::ActionView::Helpers::PrototypeHelper, :build_callbacks, :dojo) do
        Drails::PrototypeOverride.override
      end.should be_true
    end

    it "overrides ActionView::Helpers::PrototypeHelper.options_for_ajax" do
      test_alias_method_chained(::ActionView::Helpers::PrototypeHelper, :options_for_ajax, :dojo) do
        Drails::PrototypeOverride.override
      end.should be_true
    end
  end
end