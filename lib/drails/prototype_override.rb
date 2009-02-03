module Drails
  module PrototypeOverride
    def PrototypeOverride.override
      ::ActionView::Helpers::PrototypeHelper.module_eval do
        include Drails::PrototypeHelper    

        alias_method_chain :periodically_call_remote, :dojo
        alias_method_chain :remote_function, :dojo

        protected
        alias_method_chain :build_callbacks, :dojo
      end
    end

  end
end