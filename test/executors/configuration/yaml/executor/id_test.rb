require "executors/configuration/configurator_logging_test"

class IdTest < Test::Unit::TestCase
  include ConfiguratorLoggingTest

  def setup
    @method = "load_yaml_file"
    @files = [ File.join(File.dirname(__FILE__), self.class.name.split(/(?=[A-Z])/).join("_").downcase) + ".yml",
               File.join(File.dirname(__FILE__), self.class.name.split(/(?=[A-Z])/).join("_").downcase) + "_duplicate.yml",
               File.join(File.dirname(__FILE__), self.class.name.split(/(?=[A-Z])/).join("_").downcase) + "_duplicate_2.yml"]
    @logs = [
      { :level => "error", :message => "Loading YAML document. Error encountered on line 3. 'duplicate': is already used at '/0/id'. Aborting" },
      { :level => "error", :message => "Loading YAML executor definition. \"id\" of \"duplicate\" has already been defined. Duplicates not allowed. Skipping" }
    ]
  end
end