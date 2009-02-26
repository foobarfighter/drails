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
      # BEGIN: Gathers all prebuilt files
      release_root = "#{RAILS_ROOT}/public/javascripts/dojo/release"
      release_dir = "#{release_root}/dojo/dojo"
      build_profile_files = FileList[RAILS_ROOT + "/public/javascripts/*.profile.js"]
      prebuilt_files = build_profile_files.collect do |f|
        build_file = File.basename(f).gsub(/.profile.js$/, ".js")
        uncompressed_build_file = build_file + ".uncompressed.js"
        [build_file, uncompressed_build_file]
      end
      prebuilt_files << ["dojo.js", "dojo.js.uncompressed.js"]
      prebuilt_files.flatten!
      # END: Gathers all prebuilt files
      
      prebuilt_files.each do |f|
        cp File.join(release_dir, f), "#{RAILS_ROOT}/public/javascripts/#{f}", :verbose => true
      end
    end
    
    desc "Cleans the release directory"
    task :clean do
      release_root = "#{RAILS_ROOT}/public/javascripts/dojo/release"
      rm_rf release_root
    end
    
    desc "Builds, copys the prebuilt files, and cleans the release directory"
    task :full => [:do, :copy, :clean] do
    end
    
  end
end
