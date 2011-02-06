require "yaml_parser/yaml_parser_logging_test"

class YamlParserEmptyTest < Test::Unit::TestCase
  include YamlParserLoggingTest

  def setup
    @expected = [
      { :level => "error", :message => "YAML executor definition is empty" }
    ]
    @yaml_string = ""
  end
end