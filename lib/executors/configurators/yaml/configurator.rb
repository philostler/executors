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
        TYPE_SCHEDULED = [ "scheduled", "single_scheduled" ]
        SIZE_KEY = "size"
        SIZE_REQUIRING_TYPES = [ "fixed", "scheduled" ]
        TASKS_KEY = "tasks"
        CLASS_KEY = "class"
        SCHEDULE_KEY = "schedule"
        START_KEY = "start"
        EVERY_KEY = "every"

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
                if e[TASKS_KEY]
                  e[TASKS_KEY].each do |t|
                    create_task t[CLASS_KEY], t[SCHEDULE_KEY], t[START_KEY], t[EVERY_KEY]
                  end
                end
              end
            else
              logger.error { "Validating YAML document. Document is empty. Aborting" } unless logger.nil?
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
            errors_encountered = false
            parser_errors.each do |e|
              case e
                when ValidationWarn
                  logger.warn { "Validating YAML document. The following validation error occurred on line " + e.linenum.to_s + " => " + e.message } unless logger.nil?
                else
                  logger.error { "Validating YAML document. The following validation error occurred on line " + e.linenum.to_s + " => " + e.message } unless logger.nil?
                  errors_encountered = true
              end
            end
            if errors_encountered
              logger.error { "Validating YAML document. Validation error(s) occurred while loading document. Aborting" } unless logger.nil?
            end
          end

          return errors
        end
        def create_executor id, type, size
          executor = Executors::Factory.create_executor type, size

          begin
            add id, executor
          rescue ArgumentError
            logger.error { "Implementing YAML document. \"id\" of \"" + id + "\" has already been defined. Duplicates not allowed. Skipping" } unless logger.nil?; next
          end
        end
        def create_task clazz, schedule, start, every
          clazz = Object.const_get(clazz).new
          start = start.split "."
          every = every.split "."
        end
      end
    end
  end
end