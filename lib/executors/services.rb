java_import java.util.concurrent.ExecutorService
java_import java.util.concurrent.ScheduledExecutorService
java_import java.util.concurrent.TimeUnit

module Executors
  class Services
    class << self
      YAML_EXECUTOR_ID_KEY = "id"
      YAML_EXECUTOR_TYPE_KEY = "type"
      YAML_EXECUTOR_TYPE_VALID = [ "cached", "fixed", "scheduled", "single" ]
      YAML_EXECUTOR_SIZE_KEY = "size"
      YAML_EXECUTOR_TYPES_REQUIRING_SIZE = [ "fixed", "scheduled" ]

      YAML_COMMMAND_COMMANDS_KEY = "commands"
      YAML_COMMMAND_COMMAND_KEY = "command"
      YAML_COMMMAND_INITIAL_KEY = "initial"
      YAML_COMMMAND_DELAY_KEY = "delay"
      YAML_COMMMAND_UNITS_KEY = "units"
      YAML_COMMAND_UNITS_VALID = [ "days", "hours", "microseconds", "milliseconds", "minutes", "nanoseconds", "seconds" ]

      attr_accessor :logger
      @@executors = {}

      def get(id)
        @@executors[id]
      end

      def get_executor(type, size)
        case type
          when "cached"
            return java.util.concurrent.Executors.new_cached_thread_pool
          when "fixed"
            return java.util.concurrent.Executors.new_fixed_thread_pool size
          when "scheduled"
            return java.util.concurrent.Executors.new_scheduled_thread_pool size
          when "single"
            return java.util.concurrent.Executors.new_single_thread_executor
          else
            return nil
        end
      end

      def load_yaml_string(yaml)
        # Each executor definition
        yaml.each do |y|
          # Executor identifier
          id = parse_symbol y[YAML_EXECUTOR_ID_KEY]
          if id.nil?
            logger.warn { "YAML executor definition does not have an id. Skipping" } unless logger.nil?
            next
          end
          if @@executors.include?(id)
            logger.warn { "YAML executor definition for id \"" + id.to_s + "\" has already been defined. Duplicates not allowed. Skipping" } unless logger.nil?
            next
          end

          # Executor type
          type = parse_string y[YAML_EXECUTOR_TYPE_KEY]
          if type.nil?
            logger.warn { "YAML executor definition for id \"" + id.to_s + "\" does not have an type. Skipping" } unless logger.nil?
            next
          end
          if !YAML_EXECUTOR_TYPE_VALID.include?(type)
            logger.warn { "YAML executor definition for id \"" + id.to_s + "\" contains invalid type \"" + type + "\". Skipping" } unless logger.nil?
            next
          end

          # Executor size
          size = parse_string y[YAML_EXECUTOR_SIZE_KEY]
          if YAML_EXECUTOR_TYPES_REQUIRING_SIZE.include?(type)
            if size.nil?
              logger.warn { "YAML executor definition for id \"" + id.to_s + "\" of type \"" + type + "\" does not have a size. Skipping" } unless logger.nil?
              next
            end
            if size.to_i < 1
              logger.warn { "YAML executor definition for id \"" + id.to_s + "\" has an invalid size of \"" + size.to_s + "\". Size must be bigger than 0. Skipping" } unless logger.nil?
              next
            end
          end

          # Create & set executor
          executor = get_executor type, size
          if executor.nil?
            logger.error { "Unknown executor type \"" + type + "\". Unable to create executor" } unless logger.nil?
            next
          end
          set id, executor

          # Command definitions present?
          if !y[YAML_COMMMAND_COMMANDS_KEY].nil?
            # Each command definition
            y[YAML_COMMMAND_COMMANDS_KEY].each do |c|
              # Command commmand class
              command = parse_string c[YAML_COMMMAND_COMMAND_KEY]
              if command.nil?
                logger.warn { "YAML command definition for executor id \"" + id.to_s + "\" does not have a command attribute. Skipping" } unless logger.nil?
                next
              end
              command = parse_object command
              if command.nil?
                logger.warn { "YAML command definition for executor id \"" + id.to_s + "\" does not reference a valid class. Skipping" } unless logger.nil?
                next
              end

              case executor
                when ScheduledExecutorService
                  # Command initial
                  initial = parse_string c[YAML_COMMMAND_INITIAL_KEY]
                  if initial.nil?
                    logger.warn { "YAML command definition for executor id \"" + id.to_s + "\" does not have an initial. Skipping" } unless logger.nil?
                    next
                  end
                  if initial.to_i < 1
                    logger.warn { "YAML command definition for executor id \"" + id.to_s + "\" has an invalid initial of \"" + initial.to_s + "\". Initial must be bigger than 0. Skipping" } unless logger.nil?
                    next
                  end

                  # Command delay
                  delay = parse_string c[YAML_COMMMAND_DELAY_KEY]
                  if delay.nil?
                    logger.warn { "YAML command definition for executor id \"" + id.to_s + "\" does not have a delay. Skipping" } unless logger.nil?
                    next
                  end
                  if delay.to_i < 1
                    logger.warn { "YAML command definition for executor id \"" + id.to_s + "\" has an invalid delay of \"" + delay.to_s + "\". Delay must be bigger than 0. Skipping" } unless logger.nil?
                    next
                  end

                  # Command units
                  units = parse_string c[YAML_COMMMAND_UNITS_KEY]
                  if units.nil?
                    logger.warn { "YAML command definition for executor id \"" + id.to_s + "\" does not have a units. Skipping" } unless logger.nil?
                    next
                  end
                  if !YAML_COMMAND_UNITS_VALID.include?(units.downcase)
                    logger.warn { "YAML command definition for executor id \"" + id.to_s + "\" with units of \"" + units + "\" is not valid. Skipping" } unless logger.nil?
                    next
                  end
                  units = TimeUnit.value_of units.upcase

                  executor.schedule_with_fixed_delay command, initial, delay, units
                when ExecutorService
                  executor.submit command
              end
            end
          end
        end
      end

      def parse_object(value)
        if value.nil?
          return nil
        else
          begin
            return Object.const_get(value).new
          rescue NameError
            return nil
          end
        end  
      end

      def parse_string(value)
        if value.nil?
          return nil
        else
          return value
        end  
      end

      def parse_symbol(value)
        if value.nil?
          return nil
        else
          return value.to_sym
        end  
      end

      def set(id, executor)
        @@executors[id] = executor
      end
    end
  end
end