require "yaml_parser/yaml_parser_logging_test"

class ValidationIdTest < Test::Unit::TestCase
  include YamlParserLoggingTest

  def setup
    @expected = [
      { :level => "warn", :message => "YAML executor definition does not have an id. Skipping" },
      { :level => "warn", :message => "YAML executor definition does not have an id. Skipping" },
      { :level => "warn", :message => "YAML executor definition id must be of type String. Skipping" },
      { :level => "warn", :message => "YAML executor definition id must be of type String. Skipping" },
      { :level => "warn", :message => "YAML executor definition for id \"duplicate\" has already been defined. Duplicates not allowed. Skipping" }
    ]
    @yaml_string = "
      - no_id: no_id
      - id:
      - id: true
      - id: 0
      - id: duplicate
        type: single
      - id: duplicate
        type: single
"
  end
end