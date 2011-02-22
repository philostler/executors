require "executors/configuration/configurator_logging_test"

class EmptyTest < Test::Unit::TestCase
  include ConfiguratorLoggingTest

  def setup
    @method = "load_yaml_file"
    @files = [ File.join(File.dirname(__FILE__), self.class.name.split(/(?=[A-Z])/).join("_").downcase) + ".yml" ]
    @logs = [
      { :level => "error", :message => "Loading YAML document. Document is empty. Aborting" }
    ]
  end
end