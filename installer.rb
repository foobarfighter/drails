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

require 'rubygems'
require 'fileutils'

module Drails
  class Installer
    include FileUtils

    attr_reader :rails_root, :drails_root

    REQUIRE_PREREQUISITES_ERROR =<<MSG

  ** Installation Error:
  **
  ** d-rails requires the dojo-pkg rubygem for installation.
  ** To get dojo-pkg:
  **
  **    sudo gem install dojo-pkg
  **
  ** For more information on dojo-pkg, visit http://dojo-pkg.rubyforge.org
MSG

    def initialize(rails_root, drails_root)
      @rails_root = rails_root
      @drails_root = drails_root
    end

    def drails_scripts_dir
      File.join(drails_root, "javascripts", "drails")
    end

    def dojo_dest_dir
      File.join(rails_root, "public", "javascripts", "dojo")
    end

    def install_success_msg
      msg =<<MSG
  **
  ** d-rails was installed d-rails successfully!"
  ** d-rails installed dojo source and d-rails scripts to:"
  **"
  **    #{dojo_dest_dir}
  **"
  ** All other d-rails source files are located at:"
  **"
  **    #{drails_root}
  **
MSG
    end

    def require_prerequisites!
      if !require_dojo_pkg
        die_with_message(REQUIRE_PREREQUISITES_ERROR)
      end
      if !require_rails
        die_with_message(msg)
      end
    end

    def install!
      begin
        write_message "** Installing dojo source into your application..."
        install_dojo_source
      rescue Exception => e
        die_with_message("!! Could not install dojo sources: #{e.to_s}")
      end

      begin
        write_message "** Installing d-rails javascripts into your application..."
        install_drails_scripts
      rescue Exception => e
        die_with_message("!! Could not install d-rails javascripts: #{e.to_s}")
      end

      write_message(install_success_msg)
    end

    def die_with_message(msg)
      warn_message(msg)
      Kernel.exit(1)
    end

    def install_dojo_source
      cmd = Dojo::Commands::Dojofy.new
      Dir.chdir(rails_root) do
        cmd.install
      end
    end

    def install_drails_scripts
      cp_r drails_scripts_dir, dojo_dest_dir
    end

    def require_dojo_pkg
      begin
        require 'dojo-pkg'
      rescue LoadError => e
        return false
      end
      true
    end

    def require_rails
      File.directory?(@rails_root) && File.exists?(File.join(@rails_root, "config", "environment.rb"))
    end

    protected

    def write_message(msg)
      puts msg
    end

    def warn_message(msg)
      warn msg
    end
  end
end