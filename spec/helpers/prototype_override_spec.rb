require File.join(File.dirname(__FILE__), "../spec_helper.rb")

class TestView
  include ActionView::Helpers::PrototypeHelper
end

describe Drails::PrototypeOverride do
  describe ".override" do
    it "overrides ActionView::Helpers::PrototypeHelper.periodically_call_remote" do
      mock(::ActionView::Helpers::PrototypeHelper).alias_method_chain(:periodically_call_remote, :dojo)
      Drails::PrototypeOverride.override
    end
  end
end