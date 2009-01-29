require File.join(File.dirname(__FILE__), "../spec_helper.rb")

class TestView
  include ActionView::Helpers::PrototypeHelper
end

describe Drails::PrototypeHelper do
  attr_reader :test_view
  before do
    @test_view = TestView.new
    mock.proxy(::ActionView::Helpers::PrototypeHelper).alias_method_chain(override_method, :dojo)
    Drails::PrototypeOverride.override
  end

  describe "#periodically_call_remote_with_dojo" do
    attr_reader :helper_output

    def override_method
      :periodically_call_remote
    end

    before do
      @helper_output = test_view.periodically_call_remote
      helper_output.should_not be_blank
    end


  end
end