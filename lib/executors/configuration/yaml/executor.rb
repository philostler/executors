# YAML configuration executor.
module Executors
  module Configuration
    module Yaml
      module Executor
        ID_KEY = "id"
        TYPE_KEY = "type"
        TYPE_VALID = [ "cached", "fixed", "scheduled", "single", "single_scheduled" ]
        SIZE_KEY = "size"
        SIZE_REQUIRING_TYPES = [ "fixed", "scheduled" ]

        private
        def load_executor_yaml yaml
          # Identifier
          id = yaml[ID_KEY]
          unless id
            logger.warn { "Loading YAML executor definition. \"id\" is missing. Skipping" } unless logger.nil?; next
          end
          unless id.is_a? String
            logger.warn { "Loading YAML executor definition. \"id\" must be a string. Skipping" } unless logger.nil?; next
          end
          id = id.to_sym
          unless not get(id)
            logger.warn { "Loading YAML executor definition. \"id\" of \"" + id.to_s + "\" has already been defined. Duplicates not allowed. Skipping" } unless logger.nil?; next
          end

          # Type
          type = yaml[TYPE_KEY]
          unless type
            logger.warn { "Loading YAML executor definition \"" + id.to_s + "\". \"type\" is missing. Skipping" } unless logger.nil?; next
          end
          unless TYPE_VALID.include? type
            logger.warn { "Loading YAML executor definition \"" + id.to_s + "\". \"type\" must be a executor type. Skipping" } unless logger.nil?; next
          end

          # Size
          size = yaml[SIZE_KEY]
          if SIZE_REQUIRING_TYPES.include? type
            unless size
              logger.warn { "Loading YAML executor definition \"" + id.to_s + "\". \"size\" is missing. Skipping" } unless logger.nil?; next
            end
            unless size.is_a? Fixnum
              logger.warn { "Loading YAML executor definition \"" + id.to_s + "\". \"size\" must be a number. Skipping" } unless logger.nil?; next
            end
            unless size.to_i > 0
              logger.warn { "Loading YAML executor definition \"" + id.to_s + "\". \"size\" must be larger than 0. Skipping" } unless logger.nil?; next
            end
          else
            if size
              logger.info { "Loading YAML executor definition \"" + id.to_s + "\". \"size\" is not required. Ignored" } unless logger.nil?; next
            end
          end

          # Instantiation
          begin
            executor = Executors::Factory.create_executor type, size
            add id, executor
          rescue ArgumentError, TypeError => exception
            logger.error { "Instantiating YAML executor definition \"" + id.to_s + "\". Failed to instantiate. \"" + exception.message + "\". Skipping" } unless logger.nil?; next
          end

          return id
        end
      end
    end
  end
end