require "yaml_parser/yaml_parser_logging_test"

class ValidationSizeTest < Test::Unit::TestCase
  include YamlParserLoggingTest

  def setup
    @expected = [
      { :level => "warn", :message => "YAML executor definition for id \"identifier\" of type \"fixed\" does not have an size. Skipping" },
      { :level => "info", :message => "YAML executor definition for id \"identifier\" of type \"single\" does not require a size" },
      { :level => "warn", :message => "YAML executor definition for id \"identifier\" of type \"fixed\" has an invalid size of \"true\". Skipping" },
      { :level => "warn", :message => "YAML executor definition for id \"identifier\" of type \"fixed\" has an invalid size of \"0\". Size must be bigger than 0. Skipping" },
      { :level => "warn", :message => "YAML executor definition for id \"identifier\" of type \"fixed\" has an invalid size of \"size\". Skipping" }
    ]
    @yaml_string = "
      - id: identifier
        type: fixed
        no_size: no_size
      - id: identifier
        type: single
        size: 1
      - id: identifier
        type: fixed
        size: true
      - id: identifier
        type: fixed
        size: 0
      - id: identifier
        type: fixed
        size: size
"
  end
end