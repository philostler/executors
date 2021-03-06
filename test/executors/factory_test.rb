require "test_helper"

java_import java.util.concurrent.ExecutorService
java_import java.util.concurrent.ScheduledExecutorService

class FactoryTest < Test::Unit::TestCase
  def test_create_cached_executor
    executor = Executors::Factory.create_cached_executor
    assert_not_nil executor
    assert executor.java_kind_of? ExecutorService
  end

  def test_create_fixed_executor
    executor = Executors::Factory.create_fixed_executor 1
    assert_not_nil executor
    assert executor.java_kind_of? ExecutorService

    executor = Executors::Factory.create_fixed_executor 1000
    assert_not_nil executor
    assert executor.java_kind_of? ExecutorService

    executor = Executors::Factory.create_fixed_executor "99 string"
    assert_not_nil executor
    assert executor.java_kind_of? ExecutorService

    # size
    exception = assert_raise TypeError do
      Executors::Factory.create_fixed_executor nil
    end
    assert_equal "size cannot be nil", exception.message

    exception = assert_raise ArgumentError do
      Executors::Factory.create_fixed_executor 0
    end
    assert_equal "size must be larger than 0", exception.message

    exception = assert_raise ArgumentError do
      Executors::Factory.create_fixed_executor "string"
    end
    assert_equal "size must be larger than 0", exception.message
  end

  def test_create_scheduled_executor
    executor = Executors::Factory.create_scheduled_executor 1
    assert_not_nil executor
    assert executor.java_kind_of? ScheduledExecutorService

    executor = Executors::Factory.create_scheduled_executor 1000
    assert_not_nil executor
    assert executor.java_kind_of? ScheduledExecutorService

    executor = Executors::Factory.create_scheduled_executor "99 string"
    assert_not_nil executor
    assert executor.java_kind_of? ScheduledExecutorService

    # size
    exception = assert_raise TypeError do
      Executors::Factory.create_scheduled_executor nil
    end
    assert_equal "size cannot be nil", exception.message

    exception = assert_raise ArgumentError do
      Executors::Factory.create_scheduled_executor 0
    end
    assert_equal "size must be larger than 0", exception.message

    exception = assert_raise ArgumentError do
      Executors::Factory.create_scheduled_executor "string"
    end
    assert_equal "size must be larger than 0", exception.message
  end

  def test_create_single_executor
    executor = Executors::Factory.create_single_executor
    assert_not_nil executor
    assert executor.java_kind_of? ExecutorService
  end

  def test_create_single_scheduled_executor
    executor = Executors::Factory.create_single_scheduled_executor
    assert_not_nil executor
    assert executor.java_kind_of? ScheduledExecutorService
  end
end