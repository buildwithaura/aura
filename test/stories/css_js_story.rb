require File.expand_path('../../stories_helper', __FILE__)

class CssJsStory < Test::Unit::TestCase
  test "Raw" do
    visit '/css/test_raw.css'
    assert page.body.strip == "div { color: red }"
  end

  test "Sass" do
    visit '/css/test_sass.css'
    assert page.body.strip =~ /div.*color.*123456/m
  end

  test "admin.css" do
    visit '/css/admin.css'
    assert page.body.include?("section")
    assert page.body.include?("margin")
  end

  test "javascript" do
    visit '/js/test_javascript.js'
    assert page.body.include?('return true')
  end

  test "javascript" do
    visit '/js/test_coffee.js'
    assert page.body.include?('Skittles')
  end
end
