#!/usr/bin/env ruby

# One off script for getting the diffs between rails versions.  Sorry, this is tailored to my (Bob Remeika's) env.
# Modify this or pass in the appropriate env variables as you wish.

gem_base_path = ENV['GEM_BASE_PATH'] || "/usr/local/lib/ruby/gems/1.8/gems"
source_version = ENV['SOURCE_VERSION'] || "2.2.2"
dest_version = ENV['DEST_VERSION'] || "2.3.2"

["prototype_helper.rb", "scripaculous_helper.rb"].each do |helper_file|
  puts "diff on #{helper_file}"
  puts "======================================="
  system "diff #{gem_base_path}/actionpack-#{source_version}/lib/action_view/helpers/#{helper_file} #{gem_base_path}/actionpack-#{dest_version}/lib/action_view/helpers/#{helper_file}"
end
