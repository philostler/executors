require "executors/configuration/yaml/configurator_logging_test"

class ValidationSizeTest < Test::Unit::TestCase
  include ConfiguratorLoggingTest

  def setup
    @expected = [
      { :level => "error", :message => "Loading YAML executor definition \"identifier\". \"size\" is missing. Skipping" },
      { :level => "error", :message => "Loading YAML executor definition \"identifier\". \"size\" is missing. Skipping" },
      { :level => "error", :message => "Loading YAML executor definition \"identifier\". \"size\" must be a number. Skipping" },
      { :level => "error", :message => "Loading YAML executor definition \"identifier\". \"size\" must be larger than 0. Skipping" },
      { :level => "error", :message => "Loading YAML executor definition \"identifier\". \"size\" must be a number. Skipping" },
      { :level => "warn", :message => "Loading YAML executor definition \"identifier\". \"size\" is not required. Ignored" }
    ]
    @yaml_string = "
      - id: identifier
        type: fixed
        no_size: no_size
      - id: identifier
        type: fixed
        size:
      - id: identifier
        type: fixed
        size: true
      - id: identifier
        type: fixed
        size: 0
      - id: identifier
        type: fixed
        size: size
      - id: identifier
        type: single
        size: 1
"
  end
end