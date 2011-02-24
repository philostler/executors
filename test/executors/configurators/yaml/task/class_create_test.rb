require "executors/configurators/configurator_logging_test"

class ClassCreateTest < Test::Unit::TestCase
  include ConfiguratorLoggingTest

  def setup
    @method = "load_yaml_file"
    @files = [ File.join(File.dirname(__FILE__), self.class.name.split(/(?=[A-Z])/).join("_").downcase) + ".yml" ]
    @logs = [
      { :level => "error", :message => "Validating YAML document. The following validation error occurred on line 4 => \"class\" must be a reference to an existing class" },
      { :level => "error", :message => "Validating YAML document. Validation error(s) occurred while loading document. Aborting" }
    ]
  end
end