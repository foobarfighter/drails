require 'rubygems'
require 'activesupport'
require 'actionpack'
require 'action_view'
require 'drails'
require 'installer'

require 'spec'

Spec::Runner.configure do |config|
  config.mock_with :rr
end

def test_alias_method_chained(mod, message, feature, &block)
  method_invoked = false
  stub(mod).alias_method_chain { |func, with| method_invoked = true if (message == func && feature == with) }
  yield block if block_given?
  method_invoked
end