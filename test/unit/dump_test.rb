
require 'test_helper'

class DumpTest < Test::Unit::TestCase
  should "dump properly" do
    dump = Aura.db_dump
    assert dump.is_a?(Hash)
    assert dump.keys.include?(:settings)
    assert dump.keys.include?(:pages)

    require 'yaml'
    yml = YAML::dump(dump)
    assert_equal yml, Aura.db_dump_yaml
  end
end
