require "executors/configurators/configurator_logging_test"

class IdDuplicateTest < Test::Unit::TestCase
  include ConfiguratorLoggingTest

  def setup
    @method = "load_yaml_file"
    @files = [ File.join(File.dirname(__FILE__), self.class.name.split(/(?=[A-Z])/).join("_").downcase) + ".yml",
               File.join(File.dirname(__FILE__), self.class.name.split(/(?=[A-Z])/).join("_").downcase) + "_2.yml" ]
    @logs = [
      { :level => "error", :message => "Implementing YAML document. \"id\" of \"duplicate\" has already been defined. Duplicates not allowed. Skipping" }
    ]
  end
end