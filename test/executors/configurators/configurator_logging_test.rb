require "test_helper"

module ConfiguratorLoggingTest
  @method = nil
  @files = nil
  @logs = nil

  @invocations = nil

  def teardown
    Executors::Services.shutdown
    Executors::Services.remove_all
  end

  def test_load_file
    @invocations = 0

    Executors::Services.logger = self
    @files.each do |f|
      Executors::Services.send(@method, f)
    end

    assert_equal @logs.size, @invocations, "Unexpected number of logging invocations"
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
    assert_equal @logs[@invocations][:message], yield, "Unexpected log message"
    assert_equal @logs[@invocations][:level], level, "Unexpected log level"

    @invocations += 1
  end
end