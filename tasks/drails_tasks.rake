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

namespace :drails do
  namespace :build do
    desc "Verifies that you have the required prerequisites for creating a dojo build"
    task :require do

    end
    
    desc "Creates a dojo build in the public/javascripts/dojo/release directory"
    task :do do
      buildscripts_dir = "#{RAILS_ROOT}/public/javascripts/dojo/util/buildscripts/profiles"
      build_files = FileList[RAILS_ROOT + "/public/javascripts/*.profile.js"]
      cp build_files, buildscripts_dir
      chdir "#{buildscripts_dir}/.." do
        build_files.each do |f|
          build_file = File.basename(f)
          profile = build_file.split('.').first
          puts "\nBuilding profile: #{profile}..."
          results = `./build.sh profile=#{profile} action=release`
          puts results
          puts "Done"
          rm File.join(buildscripts_dir, build_file)
        end
      end
    end

    # desc "Generate Build File: Drails does it's best to guess at the build profile that you might from the JS source in your application"
    # task :generate do
    # 
    # end

    # desc "Creates a Dojo Build from your dojo build file"
    # task :create do
    #   
    # end
    
    # Unpublished tasks
    
  end
end
