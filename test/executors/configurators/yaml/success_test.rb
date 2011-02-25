require "executors/configurators/configurator_logging_test"

class SuccessTest < Test::Unit::TestCase
  include ConfiguratorLoggingTest

  def setup
    @method = "load_yaml_file"
    @files = [ File.join(File.dirname(__FILE__), self.class.name.split(/(?=[A-Z])/).join("_").downcase) + ".yml" ]
    @logs = [
      { :level => "info", :message => "Completed YAML document. Loaded 12 executor(s) and 7 task(s)" }
    ]
  end
end