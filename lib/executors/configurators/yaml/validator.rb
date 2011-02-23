require "executors/configurators/yaml/validation_warn"

# YAML validator.
module Executors
  module Configurators
    module Yaml
      class Validator < Kwalify::Validator
        EXECUTOR_RULE_NAME = "executor"

        @@schema = Kwalify::Yaml.load_file(File.join(File.dirname(__FILE__), "schema.yml"))

        def initialize
          super(@@schema)
        end

        def validate_hook value, rule, path, errors
          case rule.name
            when EXECUTOR_RULE_NAME
              unless Configurator::SIZE_REQUIRING_TYPES.include? value[Configurator::TYPE_KEY].downcase
                if value[Configurator::SIZE_KEY]
                  errors << ValidationWarn.new("\"size\" is not required.", path, rule, value)
                end
              end
          end
        end
      end
    end
  end
end