require "executors/configuration/yaml/task"

# YAML configuration executor.
module Executors
  module Configuration
    module Yaml
      module Executor
        include Task

        ID_KEY = "id"
        TYPE_KEY = "type"
        TYPE_VALID = [ "cached", "fixed", "scheduled", "single", "single_scheduled" ]
        SIZE_KEY = "size"
        SIZE_REQUIRING_TYPES = [ "fixed", "scheduled" ]
        TASKS_KEY = "tasks"

        private
        def load_executor_yaml yaml
          id = validate_id yaml[ID_KEY]
          type = validate_type id, yaml[TYPE_KEY]
          size = validate_size id, type, yaml[SIZE_KEY]

          executor = instantiate_executor id, type, size

          tasks = validate_tasks id, yaml[TASKS_KEY]
          if tasks
            tasks.each do |t|
              load_task_yaml t, id, executor
            end
          end
        end
        def validate_id id
          unless id
            logger.error { "Loading YAML executor definition. \"id\" is missing. Skipping" } unless logger.nil?; next
          end
          unless id.is_a? String
            logger.error { "Loading YAML executor definition. \"id\" must be a string. Skipping" } unless logger.nil?; next
          end

          id = id.to_sym
          unless not get(id)
            logger.error { "Loading YAML executor definition. \"id\" of \"" + id.to_s + "\" has already been defined. Duplicates not allowed. Skipping" } unless logger.nil?; next
          end

          return id
        end
        def validate_type id, type
          unless type
            logger.error { "Loading YAML executor definition \"" + id.to_s + "\". \"type\" is missing. Skipping" } unless logger.nil?; next
          end
          unless TYPE_VALID.include? type
            logger.error { "Loading YAML executor definition \"" + id.to_s + "\". \"type\" must be a executor type. Skipping" } unless logger.nil?; next
          end

          return type
        end
        def validate_size id, type, size
          if SIZE_REQUIRING_TYPES.include? type
            unless size
              logger.error { "Loading YAML executor definition \"" + id.to_s + "\". \"size\" is missing. Skipping" } unless logger.nil?; next
            end
            unless size.is_a? Fixnum
              logger.error { "Loading YAML executor definition \"" + id.to_s + "\". \"size\" must be a number. Skipping" } unless logger.nil?; next
            end
            unless size.to_i > 0
              logger.error { "Loading YAML executor definition \"" + id.to_s + "\". \"size\" must be larger than 0. Skipping" } unless logger.nil?; next
            end
          else
            if size
              logger.warn { "Loading YAML executor definition \"" + id.to_s + "\". \"size\" is not required. Ignored" } unless logger.nil?; next
            end
          end

          return size
        end
        def instantiate_executor id, type, size
          begin
            executor = Executors::Factory.create_executor type, size
            add id, executor

            return executor
          rescue ArgumentError, TypeError => exception
            logger.error { "Instantiating YAML executor definition \"" + id.to_s + "\". Failed to instantiate. \"" + exception.message + "\". Skipping" } unless logger.nil?; next
          end
        end
        def validate_tasks id, tasks
          if tasks
            unless tasks.is_a? Array
              logger.error { "Loading YAML executor definition \"" + id.to_s + "\". \"tasks\" must be a array. Skipping" } unless logger.nil?; next
            end
          end

          return tasks
        end
      end
    end
  end
end