require "executors/configuration/yaml/configurator_logging_test"

class ValidationClassTest < Test::Unit::TestCase
  include ConfiguratorLoggingTest

  def setup
    @expected = [
      { :level => "warn", :message => "Loading YAML task definition for \"identifier\". \"class\" is missing. Skipping" },
      { :level => "warn", :message => "Loading YAML task definition for \"identifier_two\". \"class\" is missing. Skipping" },
      { :level => "warn", :message => "Loading YAML task definition for \"identifier_three\". \"class\" must be a string. Skipping" },
      { :level => "warn", :message => "Loading YAML task definition for \"identifier_four\". \"class\" must be a string. Skipping" },
      { :level => "warn", :message => "Loading YAML task definition for \"identifier_five\". \"class\" must be a reference to an existing class. Skipping" }
    ]
    @yaml_string = "
      - id: identifier
        type: single
        tasks:
         - no_class: no_class
      - id: identifier_two
        type: single
        tasks:
         - class:
      - id: identifier_three
        type: single
        tasks:
         - class: true
      - id: identifier_four
        type: single
        tasks:
         - class: 0
      - id: identifier_five
        type: single
        tasks:
         - class: no_class
"
  end
end