require "executors/configuration/yaml/executor"
require "yaml"

# YAML configurator.
module Executors
  module Configuration
    module Yaml
      module Configurator
        include Executor

        # Loads a YAML document from the specified location and attempts instantiation from the contained configuration definition.
        #
        # ===Example Usage
        #
        # <code>Executors::Services.load_yaml_file Rails.root.join("config", "executors.yml")</code>
        def load_yaml_file file
          yaml = YAML.load_file file
          load_yaml yaml
        end

        # Loads a YAML from the specified <code>String</code> and attempts instantiation from the contained configuration definition.
        #
        # ===Example Usage
        #
        # <code>Executors::Services.load_yaml_string YAML.load_file(Rails.root.join("config", "executors.yml"))</code>
        def load_yaml_string string
          yaml = YAML.load string
          load_yaml yaml
        end

        private
        def load_yaml yaml
          unless yaml
            logger.error { "Loading YAML document. Document is empty. Aborting" } unless logger.nil?
            return nil
          end
          unless yaml.is_a? Array
            logger.error { "Loading YAML document. Document is incorrectly formed. Aborting" } unless logger.nil?
            return nil
          end

          yaml.each do |y|
            load_executor_yaml y
          end
        end
      end
    end
  end
end