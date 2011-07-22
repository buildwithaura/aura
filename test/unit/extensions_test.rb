require 'test_helper'

class ExtensionsTest < Test::Unit::TestCase
  test "Should load the needed extensions" do

    real_names   = Aura::Extension.active.map { |ext| ext.name }
    needed_names = Main.additional_extensions

    assert_equal real_names.sort, needed_names.sort
  end
end
