require 'test_helper'

class ModelTest < Test::Unit::TestCase
  setup do
    @main = Page.new(:title => "About us")
    @main.save

    @sub  = Page.new(:title => "Mission and vision", :parent_id => @main.id)
    @sub.save
  end

  test "Children" do
    # Make sure the parenting worked right
    assert @sub.parent == @main
    assert @main.children.include?(@sub)
    assert @main.submenu.include?(@sub)
  end

  test "Submenu" do
    assert @main.submenu.include?(@sub)

    @sub.update :shown_in_menu => false
    assert !@main.submenu.include?(@sub)
  end

  test "Slugs" do
    assert @main.slug == 'about-us'
    assert @sub.slug == 'mission-and-vision'

    new = Page.new(:title => 'about-us')
    new.save
    assert new.slug == 'about-us-2'
  end
end
