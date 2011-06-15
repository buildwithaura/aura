require 'test_helper'

class MigrationTest < Test::Unit::TestCase
  setup do
    @old = Page.schema
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
    Page.sync_schema
  end
end
