require 'test_helper'

class ExtensionsTest < Test::Unit::TestCase
  test "Should load the needed extensions" do

    p "Active extensions:", Aura::Extension.active

    p "Supposed to load:", Main.core_extensions
    p Main.additional_extensions

    real_names   = Aura::Extension.active.map { |ext| ext.name }
    needed_names = Main.core_extensions + Main.additional_extensions

    assert_equal real_names.sort, needed_names.sort
  end
end
