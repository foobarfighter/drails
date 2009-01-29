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