require "executors/configuration/yaml/configurator_logging_test"

class ValidationTypeTest < Test::Unit::TestCase
  include ConfiguratorLoggingTest

  def setup
    @expected = [
      { :level => "error", :message => "Loading YAML executor definition \"identifier\". \"type\" is missing. Skipping" },
      { :level => "error", :message => "Loading YAML executor definition \"identifier\". \"type\" is missing. Skipping" },
      { :level => "error", :message => "Loading YAML executor definition \"identifier\". \"type\" must be a executor type. Skipping" },
      { :level => "error", :message => "Loading YAML executor definition \"identifier\". \"type\" must be a executor type. Skipping" }
    ]
    @yaml_string = "
      - id: identifier
        no_type: no_type
      - id: identifier
        type:
      - id: identifier
        type: true
      - id: identifier
        type: 0
"
  end
end