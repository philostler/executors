require "executors/configurators/yaml/configurator_logging_test"

class ValidationEveryTest < Test::Unit::TestCase
  include ConfiguratorLoggingTest

  def setup
    @expected = [
      { :level => "error", :message => "Loading YAML task definition for \"identifier\". \"every\" is missing. Skipping" },
      { :level => "error", :message => "Loading YAML task definition for \"identifier_two\". \"every\" is missing. Skipping" },
      { :level => "error", :message => "Loading YAML task definition for \"identifier_three\". \"every\" is malformed. Skipping" },
      { :level => "error", :message => "Loading YAML task definition for \"identifier_four\". \"every\" is malformed. Skipping" },
      { :level => "error", :message => "Loading YAML task definition for \"identifier_five\". \"every\" is malformed. Skipping" },
      { :level => "error", :message => "Loading YAML task definition for \"identifier_six\". \"every\" is malformed. Skipping" },
      { :level => "error", :message => "Loading YAML task definition for \"identifier_seven\". \"every\" must be larger than 0. Skipping" },
      { :level => "error", :message => "Loading YAML task definition for \"identifier_eight\". \"every\" must be larger than 0. Skipping" },
      { :level => "error", :message => "Loading YAML task definition for \"identifier_nine\". \"every\" must be a units type. Skipping" },
      { :level => "error", :message => "Loading YAML task definition for \"identifier_ten\". \"every\" must be a units type. Skipping" }
    ]
    @yaml_string = "
      - id: identifier
        type: single_scheduled
        tasks:
         - class: Object
      - id: identifier_two
        type: single_scheduled
        tasks:
         - class: Object
           no_every: no_every
      - id: identifier_three
        type: single_scheduled
        tasks:
         - class: Object
           every: true
      - id: identifier_four
        type: single_scheduled
        tasks:
         - class: Object
           every: 0
      - id: identifier_five
        type: single_scheduled
        tasks:
         - class: Object
           every: true-true
      - id: identifier_six
        type: single_scheduled
        tasks:
         - class: Object
           every: true.true.true
      - id: identifier_seven
        type: single_scheduled
        tasks:
         - class: Object
           every: -1.true
      - id: identifier_eight
        type: single_scheduled
        tasks:
         - class: Object
           every: -1000.true
      - id: identifier_nine
        type: single_scheduled
        tasks:
         - class: Object
           every: 1.true
      - id: identifier_ten
        type: single_scheduled
        tasks:
         - class: Object
           every: 1.no_units
"
  end
end