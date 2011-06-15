require 'test_helper'

class SettingsTest < Test::Unit::TestCase
  test "Settings" do
    assert_equal "My Site", Aura.get('site.name')

    Aura.set('site.name', 'Hello')
    assert_equal 'Hello', Aura.get('site.name')

    Aura.set('site.name', 'My Site')
  end

  test "Default settings" do
    assert_equal nil, Aura.get('jiggawatts')

    # Should do it's thing.
    Aura.default('jiggawatts', 1210)
    assert_equal 1210, Aura.get('jiggawatts')

    # Should not change.
    Aura.default('jiggawatts', 31337)
    assert_equal 1210, Aura.get('jiggawatts')

    # *Should* change.
    Aura.set('jiggawatts', 31337)
    assert_equal 31337, Aura.get('jiggawatts')

    # Should delete properly.
    last = Aura.del('jiggawatts')
    assert_equal 31337, last
    assert_equal nil, Aura.get('jiggawatts')
  end
end
