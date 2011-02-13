require "test_helper"

class ConfiguratorTest < Test::Unit::TestCase
  def test_load_yaml_file
    exception = assert_raise TypeError do
      Executors::Services.load_yaml_file nil
    end
    assert_equal "can't convert nil into String", exception.message

    exception = assert_raise TypeError do
      Executors::Services.load_yaml_file true
    end
    assert_equal "can't convert true into String", exception.message

    exception = assert_raise Errno::ENOENT do
      Executors::Services.load_yaml_file ""
    end
    assert_equal "No such file or directory - ", exception.message
  end

  def test_load_yaml_string
    exception = assert_raise TypeError do
      Executors::Services.load_yaml_string nil
    end
    assert_equal "instance of IO needed", exception.message

    exception = assert_raise TypeError do
      Executors::Services.load_yaml_string true
    end
    assert_equal "instance of IO needed", exception.message

    exception = assert_raise TypeError do
      Executors::Services.load_yaml_string 0
    end
    assert_equal "instance of IO needed", exception.message
  end
end