require "test_helper"

class YamlParserTest < Test::Unit::TestCase
  def test_load_yaml_file
    exception = assert_raise TypeError do
      Executors::Services.load_yaml_file nil
    end
    assert_equal "can't convert nil into String", exception.message

    exception = assert_raise Errno::ENOENT do
      Executors::Services.load_yaml_file ""
    end
    assert_equal "No such file or directory - ", exception.message

    exception = assert_raise IOError do
      Executors::Services.load_yaml_file 1
    end
    assert_equal "not opened for reading", exception.message
  end

  def test_load_yaml_string
    exception = assert_raise TypeError do
      Executors::Services.load_yaml_string nil
    end
    assert_equal "instance of IO needed", exception.message

    exception = assert_raise TypeError do
      Executors::Services.load_yaml_string 1
    end
    assert_equal "instance of IO needed", exception.message
  end
end