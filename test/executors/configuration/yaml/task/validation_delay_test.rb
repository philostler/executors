require "executors/configuration/yaml/configurator_logging_test"

class ValidationDelayTest < Test::Unit::TestCase
  include ConfiguratorLoggingTest

  def setup
    @expected = [
      { :level => "error", :message => "Loading YAML task definition for \"identifier\". \"delay\" is missing. Skipping" },
      { :level => "error", :message => "Loading YAML task definition for \"identifier_two\". \"delay\" is missing. Skipping" },
      { :level => "error", :message => "Loading YAML task definition for \"identifier_three\". \"delay\" must be a number. Skipping" },
      { :level => "error", :message => "Loading YAML task definition for \"identifier_four\". \"delay\" must be larger than 0. Skipping" },
      { :level => "warn", :message => "Loading YAML task definition for \"identifier_five\". \"delay\" is not required. Ignored" }
    ]
    @yaml_string = "
      - id: identifier
        type: single_scheduled
        tasks:
         - class: Object
           initial: 1
           no_delay: no_delay
      - id: identifier_two
        type: single_scheduled
        tasks:
         - class: Object
           initial: 1
           delay:
      - id: identifier_three
        type: single_scheduled
        tasks:
         - class: Object
           initial: 1
           delay: true
      - id: identifier_four
        type: single_scheduled
        tasks:
         - class: Object
           initial: 1
           delay: 0
      - id: identifier_five
        type: single
        tasks:
         - class: Object
           delay: 1
"
  end
end