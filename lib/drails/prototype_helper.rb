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
require 'set'

module Drails
  module PrototypeHelper
    
    #TODO: Figure out a way to not include this constant
    unless const_defined? :CALLBACKS
      CALLBACKS    = Set.new([ :uninitialized, :loading, :loaded,
                       :interactive, :complete, :failure, :success ] +
                       (100..599).to_a)
      AJAX_OPTIONS = Set.new([ :before, :after, :condition, :url,
                       :asynchronous, :method, :insertion, :position,
                       :form, :with, :update, :script, :type ]).merge(CALLBACKS)
    end
    
    def periodically_call_remote_with_dojo(options = {})
      dojo_require("drails.PeriodicalExecuter")
      frequency = options[:frequency] || 10
      code = "new drails.PeriodicalExecuter(function(){ #{remote_function(options)}; }, #{frequency})"
      javascript_tag(code)
    end

    def remote_function_with_dojo(options)
      javascript_options = options_for_ajax(options)
      
      update = ''
      if options[:update] && options[:update].is_a?(Hash)
        update  = []
        update << "success:'#{options[:update][:success]}'" if options[:update][:success]
        update << "failure:'#{options[:update][:failure]}'" if options[:update][:failure]
        update  = '{' + update.join(',') + '}'
      elsif options[:update]
        update << "'#{options[:update]}'"
      end
      
      function = update.empty? ?
        "new drails.Request(" :
        "new drails.Updater(#{update}, "
      
      url_options = options[:url]
      url_options = url_options.merge(:escape => false) if url_options.is_a?(Hash)
      function << "'#{escape_javascript(url_for(url_options))}'"
      function << ", #{javascript_options})"
      
      function = "#{options[:before]}; #{function}" if options[:before]
      function = "#{function}; #{options[:after]}"  if options[:after]
      function = "if (#{options[:condition]}) { #{function}; }" if options[:condition]
      function = "if (confirm('#{escape_javascript(options[:confirm])}')) { #{function}; }" if options[:confirm]
      
      return function
    end
    
    def submit_to_remote_with_dojo(name, value, options = {})
      options[:with] ||= 'dojo.formToQuery(this.form)'

      html_options = options.delete(:html) || {}
      html_options[:name] = name

      button_to_remote(value, options, html_options)
    end
    
    def observe_field_with_dojo(field_id, options = {})
      if options[:frequency] && options[:frequency] > 0
        #build_observer('Form.Element.Observer', field_id, options)
        build_observer('drails.Form.Element.Observer', field_id, options)
      else
        #build_observer('Form.Element.EventObserver', field_id, options)
        build_observer('drails.EventObserver', field_id, options)
      end
    end
    
    def observe_form_with_dojo(form_id, options = {})
      if options[:frequency]
        #build_observer('Form.Observer', form_id, options)
        build_observer('drails.Form.Observer', form_id, options)
      else
        #build_observer('Form.EventObserver', form_id, options)
        build_observer('drails.EventObserver', form_id, options)
      end
    end
    
    protected

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