module Drails
    module ScriptaculousHelper
      # TODO: Figure out a way to not include this constant
      unless const_defined? :TOGGLE_EFFECTS
        TOGGLE_EFFECTS = [:toggle_appear, :toggle_slide, :toggle_blind]
      end
      
      def visual_effect_with_dojo(name, element_id = false, js_options = {})
        element = element_id ? element_id.to_json : "element"
        
        # spaghetti
        js_options[:queue] = if js_options[:queue].is_a?(Hash)
          '{' + js_options[:queue].map {|k, v| k == :limit ? "#{k}:#{v}" : "#{k}:'#{v}'" }.join(',') + '}'
        elsif js_options[:queue]
          "'#{js_options[:queue]}'"
        end if js_options[:queue]
        
        [:endcolor, :direction, :startcolor, :scaleMode, :restorecolor].each do |option|
          js_options[option] = "'#{js_options[option]}'" if js_options[option]
        end

        if TOGGLE_EFFECTS.include? name.to_sym
          "drails.Effect.toggle(#{element},'#{name.to_s.gsub(/^toggle_/,'')}',#{options_for_javascript(js_options)});"
        else
          "new drails.Effect.#{name.to_s.camelize}(#{element},#{options_for_javascript(js_options)});"
        end
      end
      
      def sortable_element_js_with_dojo(element_id, options = {}) #:nodoc:
        options[:with]     ||= "Sortable.serialize(#{element_id.to_json})"
        options[:onUpdate] ||= "function(){" + remote_function(options) + "}"
        options.delete_if { |key, value| PrototypeHelper::AJAX_OPTIONS.include?(key) }
  
        [:tag, :overlap, :constraint, :handle].each do |option|
          options[option] = "'#{options[option]}'" if options[option]
        end
  
        options[:containment] = array_or_string_for_javascript(options[:containment]) if options[:containment]
        options[:only] = array_or_string_for_javascript(options[:only]) if options[:only]
  
        %(Sortable.create(#{element_id.to_json}, #{options_for_javascript(options)});)
      end
      
      def draggable_element_js_with_dojo(element_id, options = {}) #:nodoc:
        %(new Draggable(#{element_id.to_json}, #{options_for_javascript(options)});)
      end
      
      def drop_receiving_element_js_with_dojo(element_id, options = {}) #:nodoc:
        options[:with]     ||= "'id=' + encodeURIComponent(element.id)"
        options[:onDrop]   ||= "function(element){" + remote_function(options) + "}"
        options.delete_if { |key, value| PrototypeHelper::AJAX_OPTIONS.include?(key) }

        options[:accept] = array_or_string_for_javascript(options[:accept]) if options[:accept]    
        options[:hoverclass] = "'#{options[:hoverclass]}'" if options[:hoverclass]
        
        # Confirmation happens during the onDrop callback, so it can be removed from the options
        options.delete(:confirm) if options[:confirm]

        %(Droppables.add(#{element_id.to_json}, #{options_for_javascript(options)});)
      end
  end
end
