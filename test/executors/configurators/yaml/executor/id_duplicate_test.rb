require "executors/configurators/configurator_logging_test"

class IdDuplicateTest < Test::Unit::TestCase
  include ConfiguratorLoggingTest

  def setup
    @method = "load_yaml_file"
    @files = [ File.join(File.dirname(__FILE__), self.class.name.split(/(?=[A-Z])/).join("_").downcase) + ".yml",
               File.join(File.dirname(__FILE__), self.class.name.split(/(?=[A-Z])/).join("_").downcase) + "_2.yml" ]
    @logs = [
      { :level => "info", :message => "Completed YAML document. Loaded 1 executor(s) and 0 task(s)" },
      { :level => "error", :message => "Validating YAML document. The following validation error occurred on line 1 => \"duplicate\" has already been defined. Duplicates not allowed" },
      { :level => "error", :message => "Validating YAML document. 1 validation error(s) occurred while loading document. Aborting" }
    ]
  end
end