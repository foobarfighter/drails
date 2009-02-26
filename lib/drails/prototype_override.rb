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

module Drails
  module PrototypeOverride
    def PrototypeOverride.override
      ::ActionView::Helpers::PrototypeHelper.module_eval do
        include Drails::PrototypeHelper    

        alias_method_chain :periodically_call_remote, :dojo
        alias_method_chain :remote_function, :dojo
        alias_method_chain :submit_to_remote, :dojo
        alias_method_chain :observe_field, :dojo
        alias_method_chain :observe_form, :dojo

        protected
        alias_method_chain :options_for_ajax, :dojo
      end
    end

  end
end