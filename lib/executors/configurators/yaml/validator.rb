require "executors/configurators/yaml/validation_warn"

# YAML validator.
module Executors
  module Configurators
    module Yaml
      class Validator < Kwalify::Validator
        EXECUTOR_TYPE_RULE = "type"
        EXECUTOR_SIZE_RULE = "size"
        TASK_CLASS_RULE = "class"
        TASK_SCHEDULE_RULE = "schedule"
        TASK_START_RULE = "start"
        TASK_EVERY_RULE = "every"

        @@schema = Kwalify::Yaml.load_file(File.join(File.dirname(__FILE__), "schema.yml"))

        attr_reader :type

        def initialize
          super(@@schema)
        end

        def validate_hook value, rule, path, errors
          case rule.name
            when EXECUTOR_TYPE_RULE
              type = value.downcase
            when EXECUTOR_SIZE_RULE
              unless Configurator::SIZE_REQUIRING_TYPES.include? type
                errors << ValidationWarn.new("\"size\" is not required.", path, rule, value)
              end
            when TASK_CLASS_RULE
              begin
                Object.const_get(value).new
              rescue NameError
                errors << Kwalify::ValidationError.new("\"class\" must be a reference to an existing class", path, rule, value)
              end
            when TASK_SCHEDULE_RULE
              unless Configurator::TYPE_SCHEDULED.include? type
                errors << ValidationWarn.new("\"schedule\" is not required", path, rule, value)
              end
            when TASK_START_RULE
              unless Configurator::TYPE_SCHEDULED.include? type
                errors << ValidationWarn.new("\"start\" is not required", path, rule, value)
              end
            when TASK_EVERY_RULE
              unless Configurator::TYPE_SCHEDULED.include? type
                errors << ValidationWarn.new("\"every\" is not required", path, rule, value)
              end
          end
        end
      end
    end
  end
end