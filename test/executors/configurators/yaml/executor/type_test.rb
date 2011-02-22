require "executors/configurators/configurator_logging_test"

class TypeTest < Test::Unit::TestCase
  include ConfiguratorLoggingTest

  def setup
    @method = "load_yaml_file"
    @files = [ File.join(File.dirname(__FILE__), self.class.name.split(/(?=[A-Z])/).join("_").downcase) + ".yml" ]
    @logs = [
      { :level => "error", :message => "Loading YAML document. Error encountered on line 2. 'unknown_type': not matched to pattern /(cached|fixed|scheduled|single|single_scheduled)\\z/i. Aborting" }
    ]
  end
end