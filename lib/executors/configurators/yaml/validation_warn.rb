# YAML validation warn.
module Executors
  module Configurators
    module Yaml
      class ValidationWarn < Kwalify::ValidationError
      end
    end
  end
end