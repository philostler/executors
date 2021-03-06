require "executors/configurators/yaml/validation_warn"

# YAML validator.
module Executors
  module Configurators
    module Yaml
      class Validator < Kwalify::Validator
        DOCUMENT_RULE = "document"
        EXECUTOR_ID_RULE = "id"
        EXECUTOR_TYPE_RULE = "type"
        EXECUTOR_SIZE_RULE = "size"
        TASK_RULE = "task"
        TASK_CLASS_RULE = "class"
        TASK_SCHEDULE_RULE = "schedule"
        TASK_START_RULE = "start"
        TASK_EVERY_RULE = "every"

        SCHEDULABLE_EXECUTOR_TYPES = [ "scheduled", "single_scheduled" ]
        EXECUTOR_TYPES_REQUIRING_SIZE = [ "fixed", "scheduled" ]

        @@schema = Kwalify::Yaml.load_file(File.join(File.dirname(__FILE__), "schema.yml"))

        @executor_type = nil
        @task_start = nil

        def initialize
          super(@@schema)
        end

        def validate_hook value, rule, path, errors
          case rule.name
            when DOCUMENT_RULE
              unless value
                errors << Kwalify::ValidationError.new("Empty document", path, rule, value)
              end
            when EXECUTOR_ID_RULE
              unless not Executors::Services.get value
                errors << Kwalify::ValidationError.new("\"" + value + "\" has already been defined. Duplicates not allowed", path, rule, value)
              end
            when EXECUTOR_TYPE_RULE
              @executor_type = value.downcase
            when EXECUTOR_SIZE_RULE
              unless EXECUTOR_TYPES_REQUIRING_SIZE.include? @executor_type
                errors << ValidationWarn.new("\"size\" is not required.", path, rule, value)
              end
            when TASK_RULE
              @task_start = nil
            when TASK_CLASS_RULE
              begin
                Object.const_get(value).new
              rescue NameError
                errors << Kwalify::ValidationError.new("\"class\" must be a reference to an existing class", path, rule, value)
              end
            when TASK_SCHEDULE_RULE
              unless SCHEDULABLE_EXECUTOR_TYPES.include? @executor_type
                errors << ValidationWarn.new("\"schedule\" is not required", path, rule, value)
              end
            when TASK_START_RULE
              @task_start = value
              unless SCHEDULABLE_EXECUTOR_TYPES.include? @executor_type
                errors << ValidationWarn.new("\"start\" is not required", path, rule, value)
              end
            when TASK_EVERY_RULE
              unless SCHEDULABLE_EXECUTOR_TYPES.include? @executor_type
                errors << ValidationWarn.new("\"every\" is not required", path, rule, value)
              end
              if @task_start
                unless @task_start.split(".")[1].upcase == value.split(".")[1].upcase
                  errors << Kwalify::ValidationError.new("\"start\" and \"every\" must have matching units", path, rule, value)
                end
              end
          end
        end
      end
    end
  end
end