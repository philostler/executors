require "yaml_parser/yaml_parser_logging_test"

class YamlParserValidationTypeTest < Test::Unit::TestCase
  include YamlParserLoggingTest

  def setup
    @expected = [
      { :level => "warn", :message => "YAML executor definition for id \"identifier\" does not have an type. Skipping" },
      { :level => "warn", :message => "YAML executor definition for id \"identifier\" does not have an type. Skipping" },
      { :level => "warn", :message => "YAML executor definition for id \"identifier\" has an invalid type of \"true\". Skipping" },
      { :level => "warn", :message => "YAML executor definition for id \"identifier\" has an invalid type of \"0\". Skipping" }
    ]
    @yaml_string = "
      - id: identifier
        no_type: no_type
      - id: identifier
        type:
      - id: identifier
        type: true
      - id: identifier
        type: 0
"
  end
end