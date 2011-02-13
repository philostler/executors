require "executors/configuration/yaml/configurator_logging_test"

class EmptyTest < Test::Unit::TestCase
  include ConfiguratorLoggingTest

  def setup
    @expected = [
      { :level => "error", :message => "Loading YAML document. Document is empty. Aborting" }
    ]
    @yaml_string = ""
  end
end