module Executors
  # Instantiates implementations that conform to ExecutorService[http://download.oracle.com/javase/6/docs/api/java/util/concurrent/ExecutorService.html] and ScheduledExecutorService[http://download.oracle.com/javase/6/docs/api/java/util/concurrent/ScheduledExecutorService.html] interfaces.
  class Factory
    class << self
      CACHED_EXECUTOR = "cached"
      FIXED_EXECUTOR = "fixed"
      SCHEDULED_EXECUTOR = "scheduled"
      SINGLE_EXECUTOR = "single"
      SINGLE_SCHEDULED_EXECUTOR = "single_scheduled"

      # Returns a cached ExecutorService[http://download.oracle.com/javase/6/docs/api/java/util/concurrent/Executors.html#newCachedThreadPool()].
      def get_cached_executor
        get_executor CACHED_EXECUTOR
      end

      # Returns a fixed size ExecutorService[http://download.oracle.com/javase/6/docs/api/java/util/concurrent/Executors.html#newFixedThreadPool(int)].
      def get_fixed_executor size
        get_executor FIXED_EXECUTOR, size
      end

      # Returns a fixed size ScheduledExecutorService[http://download.oracle.com/javase/6/docs/api/java/util/concurrent/Executors.html#newScheduledThreadPool(int)].
      def get_scheduled_executor size
        get_executor SCHEDULED_EXECUTOR, size
      end

      # Returns a single threaded ExecutorService[http://download.oracle.com/javase/6/docs/api/java/util/concurrent/Executors.html#newSingleThreadExecutor()].
      def get_single_executor
        get_executor SINGLE_EXECUTOR
      end

      # Returns a single threaded ScheduledExecutorService[http://download.oracle.com/javase/6/docs/api/java/util/concurrent/Executors.html#newSingleThreadScheduledExecutor()].
      def get_single_scheduled_executor
        get_executor SINGLE_SCHEDULED_EXECUTOR
      end

      protected
      def get_executor type, size = nil
        case type
          when CACHED_EXECUTOR
            return java.util.concurrent.Executors.new_cached_thread_pool
          when FIXED_EXECUTOR
            raise ArgumentError, "size cannot be nil" unless size
            raise ArgumentError, "size must be larger than 0" unless size.to_i > 0
            return java.util.concurrent.Executors.new_fixed_thread_pool size.to_i
          when SCHEDULED_EXECUTOR
            raise ArgumentError, "size cannot be nil" unless size
            raise ArgumentError, "size must be larger than 0" unless size.to_i > 0
            return java.util.concurrent.Executors.new_scheduled_thread_pool size.to_i
          when SINGLE_EXECUTOR
            return java.util.concurrent.Executors.new_single_thread_executor
          when SINGLE_SCHEDULED_EXECUTOR
            return java.util.concurrent.Executors.new_single_thread_scheduled_executor
          else
            return nil
        end
      end
    end
  end
end