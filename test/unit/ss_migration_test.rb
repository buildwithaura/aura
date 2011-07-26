require File.expand_path('../../test_helper', __FILE__)

class SsMigrationTest < Test::Unit::TestCase
  setup do
  end

  test "migrations" do
    p db.tables

    Aura.run_migrations!

    assert_include db.tables, :pages
  end
end
