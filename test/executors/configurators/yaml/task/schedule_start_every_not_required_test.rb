require "executors/configurators/configurator_logging_test"

class ScheduleStartEveryNotRequiredTest < Test::Unit::TestCase
  include ConfiguratorLoggingTest

  def setup
    @method = "load_yaml_file"
    @files = [ File.join(File.dirname(__FILE__), self.class.name.split(/(?=[A-Z])/).join("_").downcase) + ".yml" ]
    @logs = [
      { :level => "warn", :message => "Validating YAML document. The following validation error occurred on line 5 => \"schedule\" is not required" },
      { :level => "warn", :message => "Validating YAML document. The following validation error occurred on line 6 => \"start\" is not required" },
      { :level => "warn", :message => "Validating YAML document. The following validation error occurred on line 7 => \"every\" is not required" }
    ]
  end
end