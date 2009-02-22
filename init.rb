require "yaml"

dir = File.dirname(__FILE__)
config_file = dir + "/config/drails.yml"

begin
  config = YAML.load(File.open(config_file))
  if config["drails"]["toolkit"] == "dojo"
    Drails::PrototypeOverride.override
    Drails::ScriptaculousOverride.override
  end
rescue Exception => e
  raise "Could not load d-rails config file: #{config_file}: #{e.to_s}"
end

