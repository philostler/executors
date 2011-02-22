require "rubygems"
require "kwalify"
require "executors/configurators/yaml/validator"

# YAML configurator.
module Executors
  module Configurators
    module Yaml
      module Configurator
        ID_KEY = "id"
        TYPE_KEY = "type"
        SIZE_KEY = "size"
        SIZE_REQUIRING_TYPES = [ "fixed", "scheduled" ]

        # Loads a YAML document from the specified location and attempts instantiation from the contained configuration definition.
        #
        # ===Example Usage
        #
        # <code>Executors::Services.load_yaml_file Rails.root.join("config", "executors.yml")</code>
        def load_yaml_file file
          load_yaml "parse_file", file
        end

        # Loads a YAML from the specified <code>String</code> and attempts instantiation from the contained configuration definition.
        #
        # ===Example Usage
        #
        # <code>Executors::Services.load_yaml_string YAML.load_file(Rails.root.join("config", "executors.yml"))</code>
        def load_yaml_string string
          load_yaml "parse_stream", string
        end

        private
        def load_yaml method, value
          parser = create_parser
          document = parser.send(method, value)

          unless parser_errors? parser
            if document
              document.each do |e|
                create_executor e[ID_KEY], e[TYPE_KEY], e[SIZE_KEY]
              end
            else
              logger.error { "Loading YAML document. Document is empty. Aborting" } unless logger.nil?
            end
          end
        end
        def create_parser
          validator = Validator.new
          parser = Kwalify::Yaml::Parser.new validator

          return parser
        end
        def parser_errors? parser
          parser_errors = parser.errors
          errors = (parser_errors and not parser_errors.empty?)

          if errors
            parser_errors.each do |e|
              depth = e.path.split("/").size

              logger.error { "Loading YAML document. Error encountered on line " + e.linenum.to_s + ". " + e.message + " Aborting" } unless logger.nil?
            end
          end

          return errors
        end
        def create_executor id, type, size
          unless not get(id)
            logger.error { "Loading YAML executor definition. \"id\" of \"" + id + "\" has already been defined. Duplicates not allowed. Skipping" } unless logger.nil?; next
          end

          executor = Executors::Factory.create_executor type, size
          add id, executor
        end
      end
    end
  end
end