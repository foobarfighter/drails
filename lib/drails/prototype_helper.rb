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
        build_observer('Form.Element.Observer', field_id, options)
      else
        build_observer('Form.Element.EventObserver', field_id, options)
      end
    end
    
    def observe_form_with_dojo(form_id, options = {})
      if options[:frequency]
        build_observer('Form.Observer', form_id, options)
      else
        build_observer('Form.EventObserver', form_id, options)
      end
    end
    
    # class JavaScriptGenerator
    #       private
    #         module GeneratorMethods
    #           def insert_html(position, id, *options_for_render)
    #             content = javascript_object_for(render(*options_for_render))
    #             record "Element.insert(\"#{id}\", { #{position.to_s.downcase}: #{content} });"
    #           end
    #           
    #           def replace_html(id, *options_for_render)
    #             call 'Element.update', id, render(*options_for_render)
    #           end
    #           
    #           def replace(id, *options_for_render)
    #             call 'Element.replace', id, render(*options_for_render)
    #           end
    #           
    #           def remove(*ids)
    #             loop_on_multiple_args 'Element.remove', ids
    #           end
    #           
    #           def show(*ids)
    #             loop_on_multiple_args 'Element.show', ids
    #           end
    #           
    #           def hide(*ids)
    #             loop_on_multiple_args 'Element.hide', ids
    #           end
    #           
    #           def toggle(*ids)
    #             loop_on_multiple_args 'Element.toggle', ids
    #           end
    #           
    #           private
    #             def loop_on_multiple_args(method, ids)
    #               record(ids.size>1 ?
    #                 "#{javascript_object_for(ids)}.each(#{method})" :
    #                 "#{method}(#{ids.first.to_json})")
    #             end
    #         end
    #     end
    
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

  # class JavaScriptElementProxy < JavaScriptProxy
  #     def initialize(generator, id)
  #       @id = id
  #       super(generator, "$(#{id.to_json})")
  #     end
  #     
  #     def replace_html(*options_for_render)
  #       call 'update', @generator.send(:render, *options_for_render)
  #     end
  # 
  #     def replace(*options_for_render)
  #       call 'replace', @generator.send(:render, *options_for_render)
  #     end
  #   end
  
  # holy hell... override the whole class?
  # class JavaScriptCollectionProxy < JavaScriptProxy #:nodoc:
  #     ENUMERABLE_METHODS_WITH_RETURN = [:all, :any, :collect, :map, :detect, :find, :find_all, :select, :max, :min, :partition, :reject, :sort_by, :in_groups_of, :each_slice] unless defined? ENUMERABLE_METHODS_WITH_RETURN
  #     ENUMERABLE_METHODS = ENUMERABLE_METHODS_WITH_RETURN + [:each] unless defined? ENUMERABLE_METHODS
  #     attr_reader :generator
  #     delegate :arguments_for_call, :to => :generator
  # 
  #     def initialize(generator, pattern)
  #       super(generator, @pattern = pattern)
  #     end
  # 
  #     def each_slice(variable, number, &block)
  #       if block
  #         enumerate :eachSlice, :variable => variable, :method_args => [number], :yield_args => %w(value index), :return => true, &block
  #       else
  #         add_variable_assignment!(variable)
  #         append_enumerable_function!("eachSlice(#{number.to_json});")
  #       end
  #     end
  # 
  #     def grep(variable, pattern, &block)
  #       enumerate :grep, :variable => variable, :return => true, :method_args => [pattern], :yield_args => %w(value index), &block
  #     end
  # 
  #     def in_groups_of(variable, number, fill_with = nil)
  #       arguments = [number]
  #       arguments << fill_with unless fill_with.nil?
  #       add_variable_assignment!(variable)
  #       append_enumerable_function!("inGroupsOf(#{arguments_for_call arguments});")
  #     end
  # 
  #     def inject(variable, memo, &block)
  #       enumerate :inject, :variable => variable, :method_args => [memo], :yield_args => %w(memo value index), :return => true, &block
  #     end
  # 
  #     def pluck(variable, property)
  #       add_variable_assignment!(variable)
  #       append_enumerable_function!("pluck(#{property.to_json});")
  #     end
  # 
  #     def zip(variable, *arguments, &block)
  #       add_variable_assignment!(variable)
  #       append_enumerable_function!("zip(#{arguments_for_call arguments}")
  #       if block
  #         function_chain[-1] += ", function(array) {"
  #         yield ::ActiveSupport::JSON::Variable.new('array')
  #         add_return_statement!
  #         @generator << '});'
  #       else
  #         function_chain[-1] += ');'
  #       end
  #     end
  # 
  #     private
  #       def method_missing(method, *arguments, &block)
  #         if ENUMERABLE_METHODS.include?(method)
  #           returnable = ENUMERABLE_METHODS_WITH_RETURN.include?(method)
  #           variable   = arguments.first if returnable
  #           enumerate(method, {:variable => (arguments.first if returnable), :return => returnable, :yield_args => %w(value index)}, &block)
  #         else
  #           super
  #         end
  #       end
  # 
  #       # Options
  #       #   * variable - name of the variable to set the result of the enumeration to
  #       #   * method_args - array of the javascript enumeration method args that occur before the function
  #       #   * yield_args - array of the javascript yield args
  #       #   * return - true if the enumeration should return the last statement
  #       def enumerate(enumerable, options = {}, &block)
  #         options[:method_args] ||= []
  #         options[:yield_args]  ||= []
  #         yield_args  = options[:yield_args] * ', '
  #         method_args = arguments_for_call options[:method_args] # foo, bar, function
  #         method_args << ', ' unless method_args.blank?
  #         add_variable_assignment!(options[:variable]) if options[:variable]
  #         append_enumerable_function!("#{enumerable.to_s.camelize(:lower)}(#{method_args}function(#{yield_args}) {")
  #         # only yield as many params as were passed in the block
  #         yield(*options[:yield_args].collect { |p| JavaScriptVariableProxy.new(@generator, p) }[0..block.arity-1])
  #         add_return_statement! if options[:return]
  #         @generator << '});'
  #       end
  # 
  #       def add_variable_assignment!(variable)
  #         function_chain.push("var #{variable} = #{function_chain.pop}")
  #       end
  # 
  #       def add_return_statement!
  #         unless function_chain.last =~ /return/
  #           function_chain.push("return #{function_chain.pop.chomp(';')};")
  #         end
  #       end
  # 
  #       def append_enumerable_function!(call)
  #         function_chain[-1].chomp!(';')
  #         function_chain[-1] += ".#{call}"
  #       end
  #   end
  #   
  #   class JavaScriptElementCollectionProxy < JavaScriptCollectionProxy #:nodoc:\
  #     def initialize(generator, pattern)
  #       super(generator, "$$(#{pattern.to_json})")
  #     end
  #   end
end