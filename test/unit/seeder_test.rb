require 'test_helper'

class SeederTest < Test::Unit::TestCase
  should "seed properly" do
    Main.flush!
    Main.seed!

    assert_equal 1, User.all.size
    assert_equal Main.default_user, User.all.first.email
    assert_equal nil, User.all.first.last_login

    assert Aura.site_empty?
  end
end
