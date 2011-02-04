require "executors/yaml_parser"

java_import java.lang.IllegalArgumentException
java_import java.lang.InterruptedException
java_import java.lang.RuntimePermission
java_import java.lang.SecurityException
java_import java.util.concurrent.Executor
java_import java.util.concurrent.TimeUnit

module Executors
  # Executors main interface. Provides individual and collective operations against executors as well as parsing access.
  class Services
    extend Executors::YamlParser

    class << self
      attr_accessor :logger

      # Adds an executor against the specified identifer.
      def add id, executor
        id = validate_id id

        raise TypeError, "executor cannot be nil" unless executor
        raise TypeError, "executor must be of type Executor" unless executor.is_a? Executor

        raise ArgumentError, "executor instance has already been added against id \"" + id.to_s + "\". Duplicates not allowed" unless not @@executors.has_key? id

        @@executors[id] = executor

        return id
      end

      # Gets the executor held against the specified identifer.
      def get id
        id = validate_id id

        return @@executors[id]
      end

      # Returns all executors in an <code>Array</code>.
      def get_all
        executors = Array.new

        @@executors.each_value do |executor|
          executors << executor
        end

        return executors
      end

      # Removes and returns the executor held against the specified identifer.
      def remove id
        id = validate_id id

        return @@executors.delete id
      end

      # Removes and returns all executors in an <code>Array</code>.
      def remove_all
        executors = Array.new

        @@executors.each_key do |id|
          executors << @@executors.delete(id)
        end

        return executors
      end

      # Attempts a shutdown of all executors, allowing all active and waiting commands to execute while rejecting requests to enqueue new commands. Returns an <code>Array</code> of identifers that either could not be confirmed as, or failed to shutdown.
      def shutdown await_termination = true, timeout = 30, units = "seconds"
        raise TypeError, "await_termination cannot be nil" unless await_termination

        raise TypeError, "timeout cannot be nil" unless timeout
        raise ArgumentError, "timeout must be larger than 0" unless timeout.to_i > 0

        raise TypeError, "units cannot be nil" unless units
        begin
          units = TimeUnit.value_of units.upcase
        rescue IllegalArgumentException
          raise ArgumentError, "units must be of value \"nanoseconds\", \"microseconds\", \"milliseconds\", \"seconds\", \"minutes\", \"hours\" or \"days\""
        end

        not_shutdown = Array.new

        @@executors.each do |id, executor|
          begin
            executor.shutdown

            if await_termination
              terminated = executor.await_termination timeout, units
              if !terminated
                not_shutdown << id
                logger.warn { "Executor with id of \"" + id.to_s + "\" timed out while awaiting shutdown. Unable to confirm shutdown" } unless logger.nil?
              end
            end
          rescue InterruptedException
            not_shutdown << id
            logger.warn { "Executor with id of \"" + id.to_s + "\" was interrupted while awaiting shutdown. Unable to confirm shutdown" } unless logger.nil?
          rescue RuntimePermission
            not_shutdown << id
            logger.warn { "Executor with id of \"" + id.to_s + "\" failed to shutdown. Security manager denied access" } unless logger.nil?
          rescue SecurityException
            not_shutdown << id
            logger.warn { "Executor with id of \"" + id.to_s + "\" failed to shutdown. Security error due to possible manipulation of threads that the caller is not permitted to modify" } unless logger.nil?
          end
        end

        return not_shutdown
      end

      # Attempts a shutdown of all active and waiting commands upon all executors. Returns an <code>Array</code> of identifers that threw an exception when shutdown was attempted.
      def shutdown_now
        shutdown_exceptions = Array.new

        @@executors.each do |id, executor|
          begin
            executor.shutdown_now
          rescue RuntimePermission
            shutdown_exceptions << id
            logger.warn { "Executor with id of \"" + id.to_s + "\" failed to shutdown. Security manager denied access" } unless logger.nil?
          rescue SecurityException
            shutdown_exceptions << id
            logger.warn { "Executor with id of \"" + id.to_s + "\" failed to shutdown. Security error due to possible manipulation of threads that the caller is not permitted to modify" } unless logger.nil?
          end
        end

        return shutdown_exceptions
      end  

      # Returns the number of executors being held.
      def size
        return @@executors.size
      end

      private
      @@executors = Hash.new

      def validate_id id
        raise TypeError, "id cannot be nil" unless id
        raise TypeError, "id must be of type String or Symbol" unless id.is_a? String or id.is_a? Symbol

        id = id.to_sym unless id.is_a? Symbol

        return id
      end
    end
  end
end