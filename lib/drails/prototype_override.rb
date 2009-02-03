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

module Drails
  module PrototypeOverride
    def PrototypeOverride.override
      ::ActionView::Helpers::PrototypeHelper.module_eval do
        include Drails::PrototypeHelper    

        alias_method_chain :periodically_call_remote, :dojo
        alias_method_chain :remote_function, :dojo

        protected
        alias_method_chain :build_callbacks, :dojo
        alias_method_chain :options_for_ajax, :dojo
      end
    end

  end
end