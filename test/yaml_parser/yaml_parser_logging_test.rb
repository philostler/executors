require "test_helper"

module YamlParserLoggingTest
  @expected = nil
  @yaml_string = nil

  @invocation_count = nil

  def teardown
    Executors::Services.remove_all
  end

  def test_load_yaml_string
    @invocation_count = 0

    Executors::Services.logger = self
    Executors::Services.load_yaml_string @yaml_string
    
    assert_equal @expected.size, @invocation_count
  end

  def debug progname = nil, &block
    assert_log "debug", progname, &block
  end

  def info progname = nil, &block
    assert_log "info", progname, &block
  end

  def warn progname = nil, &block
    assert_log "warn", progname, &block
  end

  def error progname = nil, &block
    assert_log "error", progname, &block
  end

  def fatal progname = nil, &block
    assert_log "fatal", progname, &block
  end

  private
  def assert_log level, progname = nil, &block
    expect = @expected[@invocation_count]

    assert_equal expect[:level], level
    assert_equal expect[:message], yield

    @invocation_count += 1
  end
end