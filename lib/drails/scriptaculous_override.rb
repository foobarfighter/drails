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
  module ScriptaculousOverride
    
    def ScriptaculousOverride.override
      ::ActionView::Helpers::ScriptaculousHelper.module_eval do
        include Drails::ScriptaculousHelper
        
        alias_method_chain :visual_effect, :dojo
        alias_method_chain :sortable_element_js, :dojo
        alias_method_chain :draggable_element_js, :dojo
        alias_method_chain :drop_receiving_element_js, :dojo
        
      end
    end
    
  end
end