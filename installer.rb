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

class Drails::Installer
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

  def require_prerequisites!
    if !require_dojo_pkg
      die_with_message(REQUIRE_PREREQUISITES_ERROR)
    end
    if !require_rails
      die_with_message(msg)
    end
  end

  def install!
#    begin
#      puts "** Installing dojo source into your application..."
#      install_dojo_source
#    rescue e
#      die_with_message("!! Could not install dojo sources: #{e.to_s}")
#    end
#
#    begin
#      puts "** Installing d-rails javascripts into your application..."
#      install_drails_scripts
#    rescue e
#      die_with_message("!! Could not install d-rails javascripts: #{e.to_s}")
#    end
#
#    puts "**"
#    puts "** d-rails was installed d-rails successfully!"
#    puts "** d-rails installed dojo source and d-rails scripts to:"
#    puts "**"
#    puts "**    " + File.join(RAILS_ROOT, "public", "javascripts", "dojo")
#    puts "**"
#    puts "** All other d-rails source files are located at:"
#    puts "**"
#    puts "**    #{@drails_root}"
#    puts "**"

  end

  def die_with_message(msg)
    warn(msg)
    Kernel.exit(1)
  end

  def install_dojo_source
    cmd = Dojo::Commands::Dojofy.new
    Dir.chdir(rails_root) do
      cmd.install
    end
  end

  def install_drails_scripts
    cp_r File.join(DRAILS_ROOT, "javascripts", "drails"),
            File.join(RAILS_ROOT, "public", "javascripts", "dojo")
  end

  def require_dojo_pkg
    begin
      Kernel.require 'dojo-pkg'
    rescue LoadError => e
      return false
    end
    true
  end

  def require_rails
    File.directory?(@rails_root) && File.exists?(File.join(@rails_root, "config", "environment.rb"))  
  end
end