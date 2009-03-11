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

namespace :drails do
  namespace :build do
    
    desc "Creates a dojo build in the public/javascripts/dojo/release directory"
    task :do do
      buildscripts_dir = "#{RAILS_ROOT}/public/javascripts/dojo/util/buildscripts/profiles"
      build_profile_files = FileList[RAILS_ROOT + "/public/javascripts/*.profile.js"]
      cp build_profile_files, buildscripts_dir
      chdir "#{buildscripts_dir}/.." do
        build_profile_files.each do |f|
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
    
    desc "Copy the prebuilt files into the applications public/javascripts directory"
    task :copy do
      release_root = "#{RAILS_ROOT}/public/javascripts/dojo/release"
      cp_r release_root, "#{RAILS_ROOT}/public/javascripts", :verbose => true
    end
    
    desc "Cleans the release directory"
    task :clean do
      release_destination = "#{RAILS_ROOT}/public/javascripts/release"
      release_root = "#{RAILS_ROOT}/public/javascripts/dojo/release"
      rm_rf release_destination if File.directory?(release_destination)
      rm_rf release_root if File.directory?(release_root)
    end
    
    desc "Builds, copys the prebuilt files, and cleans the release directory"
    task :full => [:clean, :do, :copy] do
      release_root = "#{RAILS_ROOT}/public/javascripts/dojo/release"
      rm_rf release_root if File.directory?(release_root)
    end
    
  end
end
