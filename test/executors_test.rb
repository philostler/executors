require "executors/factory_test"
require "executors/services_test"

require "executors/configurators/yaml/empty_test"
require "executors/configurators/yaml/success_test"

require "executors/configurators/yaml/executor/id_duplicate_test"
require "executors/configurators/yaml/executor/size_not_required_test"

require "executors/configurators/yaml/task/class_create_test"
require "executors/configurators/yaml/task/schedule_start_every_not_required_test"
require "executors/configurators/yaml/task/start_every_matching_units_test"