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

    def options_for_ajax_with_dojo(options)
#      js_options = build_callbacks(options)
#
#      url_options = options[:url]
#      url_options = url_options.merge(:escape => false) if url_options.is_a? Hash
#      js_options['url'] = "'#{url_for(url_options)}'"
#      js_options['sync'] = options[:type] == :synchronous
#
#
#      if options[:form]
#        js_options['form'] = 'this'
#      elsif options[:submit]
#        js_options['form'] = "dojo.byId('#{options[:submit]}')"
#      elsif options[:with]
#        xhr_content = options[:with]
#      end
#
#      if protect_against_forgery? && !options[:form]
#        xhr_content ||= "'"
#        xhr_content << " + '&" unless xhr_content == "'"
#        xhr_content << "#{request_forgery_protection_token}=' + encodeURIComponent('#{escape_javascript form_authenticity_token}')"
#      end
#
#      js_options['content'] = "dojo.queryToObject(#{xhr_content})" if options[:form].nil?
#
#      options_for_javascript(js_options)
    end

    def build_callbacks_with_dojo(options)
      options.inject({}) do |callbacks, (event, code)|
        cb = case event
        when :complete: 'handle'
        when :success:  'load'
        when :failure:   'error'
        when :loaded, :loading, :interactive, :uninitialized, 100..599
          raise Drails::IncompatibilityError, "currently the only callbacks supported are [:complete, :success, :failure]"
        end
        callbacks[cb] = "function(request){" + code + "}"
        callbacks
      end
    end

  end
end