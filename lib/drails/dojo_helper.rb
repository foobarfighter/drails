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
  module DojoHelper
    def dojo_require(mod)
      "dojo.require('#{mod}')"
    end

    #TODO: Specs pending
    def javascript_include_dojo(options = nil)
      default_options = { :drails => true, :build => false }
      options = default_options.merge(options || {})

      if options[:build]
        concat javascript_include_tag "release/dojo/dojo/dojo"
        concat javascript_include_tag "release/dojo/dojo/#{options[:build]}"
      else
        concat javascript_include_tag "dojo/dojo/dojo"
        javascript_tag do
          dojo_register_module_path("drails", drails_javascript_path("dojo/drails")) +
                  dojo_require("drails.common")
        end
      end
    end

    def dojo_register_module_path(*args)
      module_name, module_path = *args
      module_path = drails_javascript_path(module_name) unless module_path
      "dojo.registerModulePath(\"#{module_name}\", \"#{module_path}\");\n"
    end

    def drails_javascript_path(path)
      javascript_path(path).gsub(/\.js$/, "")
    end

  end
end