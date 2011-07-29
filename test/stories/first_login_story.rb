require File.expand_path('../../stories_helper', __FILE__)

class FirstLoginStory < Test::Unit::TestCase
  test "First login" do
    visit '/logout'
    visit '/login'

    assert_location '/login'
    assert page.has_content?('Login')
    assert page.has_css?('form')

    fill_in 'username', :with => 'test@sinefunc.com'
    fill_in 'password', :with => 'massive'

    click_button 'Login'

    # Go back to login page
    assert_location '/login'
    assert page.has_content?('Try again!')

    fill_in 'username', :with => Main.default_user
    fill_in 'password', :with => Main.default_password

    click_button 'Login'

    # First visit!
    assert_location '/admin/welcome'
  end
end
