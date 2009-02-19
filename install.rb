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

$LOAD_PATH << File.dirname(__FILE__)

require 'rubygems'
require 'fileutils'
require 'installer'

installer = Drails::Installer.new(RAILS_ROOT, File.dirname(__FILE__))
installer.require_prerequisites!
installer.install!


