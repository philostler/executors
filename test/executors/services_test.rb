require "test_helper"

class ServicesTest < Test::Unit::TestCase
  def teardown
    Executors::Services.remove_all
  end

  def test_add
    id = "id"
    executor = create_test_executor

    returned_id = Executors::Services.add id, executor

    assert_equal id.to_sym, returned_id
    assert_equal 1, Executors::Services.size

    # id
    exception = assert_raise TypeError do
      Executors::Services.add nil, nil
    end
    assert_equal "id cannot be nil", exception.message

    exception = assert_raise TypeError do
      Executors::Services.add true, nil
    end
    assert_equal "id must be a string or symbol", exception.message

    exception = assert_raise TypeError do
      Executors::Services.add 0, nil
    end
    assert_equal "id must be a string or symbol", exception.message

    # executor
    exception = assert_raise TypeError do
      Executors::Services.add "id", nil
    end
    assert_equal "executor cannot be nil", exception.message

    exception = assert_raise TypeError do
      Executors::Services.add "id", true
    end
    assert_equal "executor must be a executor", exception.message

    exception = assert_raise TypeError do
      Executors::Services.add "id", 0
    end
    assert_equal "executor must be a executor", exception.message

    # id, executor
    exception = assert_raise ArgumentError do
      executor = create_test_executor
      Executors::Services.add "id", executor
      Executors::Services.add "id_two", executor
    end
    assert_equal "executor instance has already been defined for \"id\". Duplicates not allowed", exception.message
  end

  def test_get
    id = "id"
    executor = create_test_executor

    returned_id = Executors::Services.add id, executor
    returned_executor = Executors::Services.get id
    returned_id_executor = Executors::Services.get returned_id

    assert_equal id.to_sym, returned_id
    assert_equal executor, returned_executor
    assert_equal executor, returned_id_executor

    # id
    exception = assert_raise TypeError do
      Executors::Services.get nil
    end
    assert_equal "id cannot be nil", exception.message

    exception = assert_raise TypeError do
      Executors::Services.get true
    end
    assert_equal "id must be a string or symbol", exception.message

    exception = assert_raise TypeError do
      Executors::Services.get 0
    end
    assert_equal "id must be a string or symbol", exception.message
  end

  def test_get_all
    id = "id"
    id_two = "id_two"
    executor = create_test_executor
    executor_two = create_test_executor

    Executors::Services.add id, executor
    Executors::Services.add id_two, executor_two

    returned_executors = Executors::Services.get_all

    assert returned_executors.kind_of? Array
    assert_equal 2, returned_executors.size
    assert returned_executors.include? executor
    assert returned_executors.include? executor_two
  end

  def test_remove
    id = "id"
    executor = create_test_executor

    Executors::Services.add id, executor

    returned_executor = Executors::Services.remove id
    returned_no_executor = Executors::Services.remove id

    assert_equal 0, Executors::Services.size
    assert_equal executor, returned_executor
    assert_nil returned_no_executor

    #id
    exception = assert_raise TypeError do
      Executors::Services.remove nil
    end
    assert_equal "id cannot be nil", exception.message

    exception = assert_raise TypeError do
      Executors::Services.remove true
    end
    assert_equal "id must be a string or symbol", exception.message

    exception = assert_raise TypeError do
      Executors::Services.remove 0
    end
    assert_equal "id must be a string or symbol", exception.message
  end

  def test_remove_all
    id = "id"
    id_two = "id_two"
    executor = create_test_executor
    executor_two = create_test_executor

    Executors::Services.add id, executor
    Executors::Services.add id_two, executor_two

    returned_executors = Executors::Services.remove_all
    returned_no_executors = Executors::Services.remove_all

    assert returned_executors.kind_of? Array
    assert_equal 0, Executors::Services.size
    assert_equal 2, returned_executors.size
    assert returned_executors.include? executor
    assert returned_executors.include? executor_two
    assert returned_no_executors.empty?
  end

  def test_shutdown
    id = "id"
    id_two = "id_two"
    executor = create_test_executor
    executor_two = create_test_executor

    Executors::Services.add id, executor
    Executors::Services.add id_two, executor_two

    not_shutdown_executors = Executors::Services.shutdown
    returned_executors = Executors::Services.get_all

    assert not_shutdown_executors.kind_of? Array
    assert_equal 0, not_shutdown_executors.size
    returned_executors.each do |executor|
      assert executor.is_shutdown
    end

    # await_termination
    exception = assert_raise TypeError do
      Executors::Services.shutdown nil
    end
    assert_equal "await_termination cannot be nil", exception.message

    # timeout
    exception = assert_raise TypeError do
      Executors::Services.shutdown true, nil
    end
    assert_equal "timeout cannot be nil", exception.message

    exception = assert_raise TypeError do
      Executors::Services.shutdown true, true
    end
    assert_equal "timeout must be a number", exception.message

    exception = assert_raise ArgumentError do
      Executors::Services.shutdown true, 0
    end
    assert_equal "timeout must be larger than 0", exception.message

    # units
    exception = assert_raise TypeError do
      Executors::Services.shutdown true, 30, nil
    end
    assert_equal "units cannot be nil", exception.message

    exception = assert_raise TypeError do
      Executors::Services.shutdown true, 30, true
    end
    assert_equal "units must be a string", exception.message

    exception = assert_raise TypeError do
      Executors::Services.shutdown true, 30, 0
    end
    assert_equal "units must be a string", exception.message

    exception = assert_raise ArgumentError do
      Executors::Services.shutdown true, 30, "units"
    end
    assert_equal "units must be \"nanoseconds\", \"microseconds\", \"milliseconds\", \"seconds\", \"minutes\", \"hours\" or \"days\"", exception.message
  end

  def test_shutdown_now
    id = "id"
    id_two = "id_two"
    executor = create_test_executor
    executor_two = create_test_executor

    Executors::Services.add id, executor
    Executors::Services.add id_two, executor_two

    exception_executors = Executors::Services.shutdown_now
    returned_executors = Executors::Services.get_all

    assert exception_executors.kind_of? Array
    assert_equal 0, exception_executors.size
    returned_executors.each do |executor|
      assert executor.is_shutdown
    end
  end  

  def test_size
    assert_equal 0, Executors::Services.size

    id = "id"
    executor = create_test_executor
    Executors::Services.add id, executor

    assert_equal 1, Executors::Services.size

    id_two = "id_two"
    executor_two = create_test_executor
    Executors::Services.add id_two, executor_two

    assert_equal 2, Executors::Services.size
  end

  private
  def create_test_executor
    Executors::Factory.create_single_executor
  end
end