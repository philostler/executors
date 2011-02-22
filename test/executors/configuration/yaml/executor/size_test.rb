require "executors/configuration/configurator_logging_test"

class SizeTest < Test::Unit::TestCase
  include ConfiguratorLoggingTest

  def setup
    @method = "load_yaml_file"
    @files = [ File.join(File.dirname(__FILE__), self.class.name.split(/(?=[A-Z])/).join("_").downcase) + ".yml" ]
    @logs = [
      { :level => "error", :message => "Loading YAML document. Error encountered on line 3. '0': too small (< min 1). Aborting" },
      { :level => "warn", :message => "Loading YAML document. Error encountered on line 4. \"size\" is not required. Aborting" }
    ]
  end
end