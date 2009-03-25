gem 'rails', ENV['RAILS_VERSION']
require 'action_view'

class TestView
  include ActionView::Helpers::PrototypeHelper
  include ActionView::Helpers::ScriptaculousHelper
  include ActionView::Helpers::JavaScriptHelper
  include ActionView::Helpers::TagHelper

  def url_for(params)
    return "http://somemockurl.com"
  end

  def protect_against_forgery?
    false
  end
  
  def request_forgery_protection_token
    "my_request_forgery_protection_token"
  end
end