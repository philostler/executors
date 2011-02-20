require "executors/configuration/yaml/configurator_logging_test"

class ValidationStartTest < Test::Unit::TestCase
  include ConfiguratorLoggingTest

  def setup
    @expected = [
      { :level => "warn", :message => "Loading YAML task definition for \"identifier\". \"start\" is not required. Ignored" },
      { :level => "warn", :message => "Loading YAML task definition for \"identifier_two\". \"start\" is not required. Ignored" },
      { :level => "error", :message => "Loading YAML task definition for \"identifier_three\". \"start\" must be a string. Skipping" },
      { :level => "error", :message => "Loading YAML task definition for \"identifier_four\". \"start\" must be a string. Skipping" },
      { :level => "error", :message => "Loading YAML task definition for \"identifier_five\". \"start\" is incorrectly formed. Skipping" },
      { :level => "error", :message => "Loading YAML task definition for \"identifier_six\". \"start\" is incorrectly formed. Skipping" },
      { :level => "error", :message => "Loading YAML task definition for \"identifier_seven\". \"start\" must be larger than or equal to 0. Skipping" },
      { :level => "error", :message => "Loading YAML task definition for \"identifier_eight\". \"start\" must be larger than or equal to 0. Skipping" },
      { :level => "error", :message => "Loading YAML task definition for \"identifier_nine\". \"start\" must be a units type. Skipping" },
      { :level => "error", :message => "Loading YAML task definition for \"identifier_ten\". \"start\" must be a units type. Skipping" }
    ]
    @yaml_string = "
      - id: identifier
        type: single
        tasks:
         - class: Object
           start: 1.minutes
           every: 1.minutes
      - id: identifier_two
        type: single
        tasks:
         - class: Object
           start: true
           every: 1.minutes
      - id: identifier_three
        type: single_scheduled
        tasks:
         - class: Object
           start: true
      - id: identifier_four
        type: single_scheduled
        tasks:
         - class: Object
           start: 0
      - id: identifier_five
        type: single_scheduled
        tasks:
         - class: Object
           start: true-true
      - id: identifier_six
        type: single_scheduled
        tasks:
         - class: Object
           start: true.true.true
      - id: identifier_seven
        type: single_scheduled
        tasks:
         - class: Object
           start: -1.true
      - id: identifier_eight
        type: single_scheduled
        tasks:
         - class: Object
           start: -1000.true
      - id: identifier_nine
        type: single_scheduled
        tasks:
         - class: Object
           start: 1.true
      - id: identifier_ten
        type: single_scheduled
        tasks:
         - class: Object
           start: 1.no_units
"
  end
end