require "executors/configuration/yaml/configurator_logging_test"

class InvalidStringTest < Test::Unit::TestCase
  include ConfiguratorLoggingTest

  def setup
    @expected = [
      { :level => "error", :message => "Loading YAML document. Document is incorrectly formed. Aborting" }
    ]
    @yaml_string = "
      invalid yaml string
    "
  end
end