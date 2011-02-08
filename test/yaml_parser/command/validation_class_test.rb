require "yaml_parser/yaml_parser_logging_test"

class ValidationClassTest < Test::Unit::TestCase
  include YamlParserLoggingTest

  def setup
    @expected = [
      { :level => "warn", :message => "YAML command definition for executor id \"identifier\" does not have a class. Skipping" },
      { :level => "warn", :message => "YAML command definition for executor id \"identifier_two\" does not have a class. Skipping" },
      { :level => "warn", :message => "YAML command definition class for executor id \"identifier_three\" must be of type String. Skipping" },
      { :level => "warn", :message => "YAML command definition class for executor id \"identifier_four\" must be of type String. Skipping" },
      { :level => "warn", :message => "YAML command definition for executor id \"identifier_five\" does not reference a valid class. Skipping" }
    ]
    @yaml_string = "
      - id: identifier
        type: single
        commands:
         - no_command: no_command
      - id: identifier_two
        type: single
        commands:
         - class:
      - id: identifier_three
        type: single
        commands:
         - class: true
      - id: identifier_four
        type: single
        commands:
         - class: 0
      - id: identifier_five
        type: single
        commands:
         - class: no_command
"
  end
end