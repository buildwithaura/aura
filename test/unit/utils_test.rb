require File.expand_path('../../test_helper', __FILE__)

class UtilsTest < Test::Unit::TestCase
  include Aura::Utils

  test "indir" do
    assert in_dir?(Aura.gem_root('test/unit/utils_test.rb'), Aura.gem_root('test'))
    assert ! in_dir?(Aura.gem_root('app/main.rb'), Aura.gem_root('test'))
    assert ! in_dir?(Aura.gem_root('app/non/existent.rb'), Aura.gem_root('test'))
  end
end
