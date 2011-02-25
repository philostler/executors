require "rubygems"
require "kwalify"

require "executors/configurators/yaml/validator"

# YAML configurator.
module Executors
  module Configurators
    module Yaml
      module Configurator
        EXECUTOR_ID_KEY = "id"
        EXECUTOR_TYPE_KEY = "type"
        EXECUTOR_SIZE_KEY = "size"
        EXECUTOR_TASKS_KEY = "tasks"
        TASK_CLASS_KEY = "class"
        TASK_SCHEDULE_KEY = "schedule"
        TASK_START_KEY = "start"
        TASK_EVERY_KEY = "every"

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
            executors = 0
            tasks = 0
            document.each do |e|
              executor = create_executor e[EXECUTOR_ID_KEY], e[EXECUTOR_TYPE_KEY], e[EXECUTOR_SIZE_KEY]
              if e[EXECUTOR_TASKS_KEY]
                e[EXECUTOR_TASKS_KEY].each do |t|
                  create_task executor, t[TASK_CLASS_KEY], t[TASK_SCHEDULE_KEY], t[TASK_START_KEY], t[TASK_EVERY_KEY]
                  tasks += 1
                end
              end
              executors += 1
            end
            logger.info { "Completed YAML document. Loaded " + executors.to_s + " executor(s) and " + tasks.to_s + " task(s)" } unless logger.nil?
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
            errors_encountered = 0
            parser_errors.each do |e|
              case e
                when ValidationWarn
                  logger.warn { "Validating YAML document. The following validation error occurred on line " + e.linenum.to_s + " => " + e.message } unless logger.nil?
                else
                  logger.error { "Validating YAML document. The following validation error occurred on line " + e.linenum.to_s + " => " + e.message } unless logger.nil?
                  errors_encountered += 1
              end
            end
            unless errors_encountered == 0
              logger.error { "Validating YAML document. " + errors_encountered.to_s + " validation error(s) occurred while loading document. Aborting" } unless logger.nil?
            end
          end

          return errors
        end
        def create_executor id, type, size
          executor = Executors::Factory.create_executor type, size
          add id, executor

          return executor
        end
        def create_task executor, clazz, schedule, start, every
          clazz = Object.const_get(clazz).new

          case executor
            when ScheduledExecutorService
              schedule.downcase!
              if start
                start = start.split "."
              end
              every = every.split "."
              units = TimeUnit.value_of every[1].upcase

              executor.send("schedule_with_" + schedule, clazz, start ? start[0].to_i : 0, every[0].to_i, units)
            when ExecutorService
              begin
                executor.submit clazz
              rescue RejectedExecutionException
                #logger.warn { "YAML command definition for executor id \"" + id.to_s + "\" could not be accepted for execution. Skipping" } unless logger.nil?; next
              end
          end
        end
      end
    end
  end
end