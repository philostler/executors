require "executors/yaml_parser"

module Executors
  # Executor services top-level point of entry.
  class Services
    extend Executors::YamlParser

    class << self
      attr_accessor :logger
      @@executors = {}

      # Gets an executor with the specified identifer symbol.
      def get(id)
        @@executors[id]
      end

      # Returns a cached ExecutorService[http://download.oracle.com/javase/6/docs/api/java/util/concurrent/Executors.html#newCachedThreadPool()].
      def get_cached_executor()
        get_executor "cached"
      end

      # Returns a fixed ExecutorService[http://download.oracle.com/javase/6/docs/api/java/util/concurrent/Executors.html#newFixedThreadPool(int)] of the specified size.
      def get_fixed_executor(size)
        get_executor "fixed", size
      end

      # Returns a ScheduledExecutorService[http://download.oracle.com/javase/6/docs/api/java/util/concurrent/Executors.html#newScheduledThreadPool(int)] of the specified size.
      def get_scheduled_executor(size)
        get_executor "scheduled", size
      end

      # Returns a single ExecutorService[http://download.oracle.com/javase/6/docs/api/java/util/concurrent/Executors.html#newSingleThreadExecutor()].
      def get_single_executor()
        get_executor "single"
      end

      # Returns a single ScheduledExecutorService[http://download.oracle.com/javase/6/docs/api/java/util/concurrent/Executors.html#newSingleThreadScheduledExecutor()].
      def get_single_scheduled_executor()
        get_executor "single_scheduled"
      end

      # Sets an executor against the specified identifer symbol.
      def set(id, executor)
        id = id.to_sym unless id.is_a? Symbol
        @@executors[id] = executor
      end
    end
  end
end