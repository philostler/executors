require "executors/configuration/yaml/configurator_logging_test"

class ValidationScheduleTest < Test::Unit::TestCase
  include ConfiguratorLoggingTest

  def setup
    @expected = [
      { :level => "error", :message => "Loading YAML task definition for \"identifier\". \"schedule\" must be a schedule type. Skipping" }
    ]
    @yaml_string = "
      - id: identifier
        type: single_scheduled
        tasks:
         - class: Object
           schedule: no_schedule
"
  end
end