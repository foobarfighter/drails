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

    def build_callbacks_with_dojo(options)
      prefix = "function(request){"
      suffix = "}"
      callbacks = {}
      options.each do |callback, code|
        case callback
        when :complete
          callbacks['handle'] = prefix + code + suffix
        when :success
          callbacks['load'] = prefix + code + suffix
        when :failure
          callbacks['error'] = prefix + code + suffix
        when :loaded, :loading, :interactive, :uninitialized, 100..599
          raise Drails::IncompatibilityError, "currently the only callbacks supported are [:complete, :success, :failure]"
        end
      end
      callbacks
    end

  end
end