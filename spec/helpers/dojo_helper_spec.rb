####################################################################
#                                                                  #
#      Copyright (c) 2009, Bob Remeika and others                  #
#      All Rights Reserved.                                        #
#                                                                  #
#      Licensed under the MIT License.                             #
#      For more information on drails licensing, see:              #
#                                                                  #
#          http://www.opensource.org/licenses/mit-license.php      #
#                                                                  #
####################################################################

require File.join(File.dirname(__FILE__), "../spec_helper.rb")

class TestView
  include Drails::DojoHelper
end

describe Drails::DojoHelper do
  attr_reader :test_view
  before do
    @test_view = TestView.new
  end

  describe "#dojo_require" do
    it "returns dojo.require('test.module')" do
      helper_output = test_view.dojo_require('test.module')
      helper_output.should == "dojo.require('test.module')"
    end
  end

  describe "#javascript_include_dojo" do
    describe "when the build option is present" do
      it "requires dojo and the dojo build from the releases directory"
    end
    describe "when the build option is not present" do
      it "requires dojo"
      it "registers the drails module path"
      it "requires drails.common"
    end
  end

end