require "yaml_parser/yaml_parser_logging_test"

class InvalidStringTest < Test::Unit::TestCase
  include YamlParserLoggingTest

  def setup
    @expected = [
      { :level => "error", :message => "YAML executor definition is incorrectly formed" }
    ]
    @yaml_string = "
      invalid yaml string
    "
  end
end