require "executors/configurators/yaml/configurator_logging_test"

class ValidationTasksTest < Test::Unit::TestCase
  include ConfiguratorLoggingTest

  def setup
    @expected = [
      { :level => "error", :message => "Loading YAML executor definition \"identifier\". \"tasks\" must be a array. Skipping" }
    ]
    @yaml_string = "
      - id: identifier
        type: single
        tasks: no_tasks
"
  end
end