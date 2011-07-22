require File.expand_path('../../test_helper', __FILE__)

class ExtensionsTest < Test::Unit::TestCase
  test "Should load the needed extensions" do

    real_names   = Aura::Extension.active.map { |ext| ext.name }
    needed_names = Main.additional_extensions

    assert_equal real_names.sort, needed_names.sort
  end

  test "Extension.all" do
    all = Aura::Extension.all

    assert_equal 2, all.size
  end
end
