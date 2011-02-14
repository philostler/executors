require "executors/configuration/yaml/configurator_logging_test"

class ValidationIdTest < Test::Unit::TestCase
  include ConfiguratorLoggingTest

  def setup
    @expected = [
      { :level => "error", :message => "Loading YAML executor definition. \"id\" is missing. Skipping" },
      { :level => "error", :message => "Loading YAML executor definition. \"id\" is missing. Skipping" },
      { :level => "error", :message => "Loading YAML executor definition. \"id\" must be a string. Skipping" },
      { :level => "error", :message => "Loading YAML executor definition. \"id\" must be a string. Skipping" },
      { :level => "error", :message => "Loading YAML executor definition. \"id\" of \"duplicate\" has already been defined. Duplicates not allowed. Skipping" }
    ]
    @yaml_string = "
      - no_id: no_id
      - id:
      - id: true
      - id: 0
      - id: duplicate
        type: single
      - id: duplicate
        type: single
"
  end
end