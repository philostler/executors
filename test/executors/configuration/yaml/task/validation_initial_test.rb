require "executors/configuration/yaml/configurator_logging_test"

class ValidationInitialTest < Test::Unit::TestCase
  include ConfiguratorLoggingTest

  def setup
    @expected = [
      { :level => "error", :message => "Loading YAML task definition for \"identifier\". \"initial\" is missing. Skipping" },
      { :level => "error", :message => "Loading YAML task definition for \"identifier_two\". \"initial\" is missing. Skipping" },
      { :level => "error", :message => "Loading YAML task definition for \"identifier_three\". \"initial\" must be a number. Skipping" },
      { :level => "error", :message => "Loading YAML task definition for \"identifier_four\". \"initial\" must be larger than 0. Skipping" },
      { :level => "warn", :message => "Loading YAML task definition for \"identifier_five\". \"initial\" is not required. Ignored" }
    ]
    @yaml_string = "
      - id: identifier
        type: single_scheduled
        tasks:
         - class: Object
           no_initial: no_initial
      - id: identifier_two
        type: single_scheduled
        tasks:
         - class: Object
           initial:
      - id: identifier_three
        type: single_scheduled
        tasks:
         - class: Object
           initial: true
      - id: identifier_four
        type: single_scheduled
        tasks:
         - class: Object
           initial: 0
      - id: identifier_five
        type: single
        tasks:
         - class: Object
           initial: 1
"
  end
end