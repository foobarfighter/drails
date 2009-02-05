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
  module PrototypeHelper
    def periodically_call_remote_with_dojo(options = {})
      dojo_require("drails.PeriodicalExecuter")
      frequency = options[:frequency] || 10
      code = "new drails.PeriodicalExecuter(function(){ #{remote_function(options)}; }, #{frequency})"
      javascript_tag(code)
    end

    def remote_function_with_dojo(options)
      #      dojo_require "drails.Element"
      #
      #      javascript_options = options_for_ajax(options)
      #      method = "Get"
      #      if options[:method]
      #        method = options[:method].match(/[A-z]+/)[0].camelize
      #      end
      #      function = "dojo.xhr#{method}(#{javascript_options})"
      #
      #      def create_callback(id, position = nil)
      #        func = position.nil? ? "update('#{id}', response)" : "insert('#{id}', {#{position.to_s.downcase}: response})"
      #        "function(response){ drails.Element.#{func};}"
      #      end
      #
      #      updates = options[:update]
      #      if updates && updates.is_a?(Hash)
      #        success_callback = create_callback(updates[:success], options[:position]) if updates[:success]
      #        error_callback   = create_callback(updates[:failure], options[:position]) if updates[:failure]
      #        function = "#{function}.addCallback(#{success_callback})" if updates[:success]
      #        function = "#{function}.addErrback(#{error_callback})"    if updates[:failure]
      #      elsif updates
      #        both_callback = create_callback(updates, options[:position])
      #        function = "#{function}.addBoth(#{both_callback},#{both_callback})"
      #      end
      #
      #
      #      function = "#{options[:before]}; #{function}" if options[:before]
      #      function = "#{function}; #{options[:after]}"  if options[:after]
      #      function = "if (#{options[:condition]}) { #{function}; }" if options[:condition]
      #      function = "if (confirm('#{escape_javascript(options[:confirm])}')) { #{function}; }" if options[:confirm]
      #
      #      return function
    end

    protected

    # TODO: Merge possible differences between old d-rails and possibly new implementation in rails (actionpack-2.2.2)
    def options_for_ajax_with_dojo(options)
      js_options = build_callbacks(options)

      js_options['asynchronous'] = options[:type] != :synchronous
      js_options['method']       = method_option_to_s(options[:method]) if options[:method]
      js_options['insertion']    = "'#{options[:position].to_s.downcase}'" if options[:position]
      js_options['evalScripts']  = options[:script].nil? || options[:script]

      if options[:form]
        js_options['parameters'] = 'dojo.formToQuery(this)'
      elsif options[:submit]
        js_options['parameters'] = "dojo.formToQuery('#{options[:submit]}')"
      elsif options[:with]
        js_options['parameters'] = options[:with]
      end
      
      if protect_against_forgery? && !options[:form]
        if js_options['parameters']
          js_options['parameters'] << " + '&"
        else
          js_options['parameters'] = "'"
        end
        js_options['parameters'] << "#{request_forgery_protection_token}=' + encodeURIComponent('#{escape_javascript form_authenticity_token}')"
      end
      
      options_for_javascript(js_options)
    end
    
  end
end