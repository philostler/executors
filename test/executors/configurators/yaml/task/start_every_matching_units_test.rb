require "executors/configurators/configurator_logging_test"

class StartEveryMatchingUnitsTest < Test::Unit::TestCase
  include ConfiguratorLoggingTest

  def setup
    @method = "load_yaml_file"
    @files = [ File.join(File.dirname(__FILE__), self.class.name.split(/(?=[A-Z])/).join("_").downcase) + ".yml" ]
    @logs = [
      { :level => "error", :message => "Validating YAML document. The following validation error occurred on line 6 => \"start\" and \"every\" must have matching units" },
      { :level => "error", :message => "Validating YAML document. 1 validation error(s) occurred while loading document. Aborting" }
    ]
  end
end