require File.expand_path('../../test_helper', __FILE__)

class SeederTest < Test::Unit::TestCase
  should "seed properly" do
    Main.flush!
    Aura.run_migrations!
    Main.seed!

    User = Aura::Models::User

    assert_equal 1, User.all.size
    assert_equal Main.default_user, User.all.first.email
    assert_equal nil, User.all.first.last_login

    assert Aura.site_empty?
  end
end
