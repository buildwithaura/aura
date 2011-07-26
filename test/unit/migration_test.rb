require File.expand_path('../../test_helper', __FILE__)

class MigrationTest < Test::Unit::TestCase
  Page = Aura::Models::Page

  setup do
    @old = Page.schema
    Page.set_schema do
      primary_key :id
      foreign_key :parent_id
    end
  end

  test "Should not remove old stuff" do
    Page.sync_schema

    Page.set_schema do
      String :foobar
    end

    Page.sync_schema

    p "Columns:", Page.columns

    assert Page.columns.include? :foobar
    assert Page.columns.include? :id
    assert Page.columns.include? :parent_id

    Page.set_schema do
      String :meatballs
    end

    Page.sync_schema

    p "Columns after modification:", Page.columns

    assert Page.columns.include? :meatballs
    assert Page.columns.include? :foobar
    assert Page.columns.include? :id

    # These should not throw errors
    page = Page.new
    page.id
    page.parent_id
    page.foobar
  end

  teardown do
    Page.instance_variable_set :'@schema', @old
  end
end
