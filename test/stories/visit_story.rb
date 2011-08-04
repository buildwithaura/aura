require File.expand_path('../../stories_helper', __FILE__)

class Main
  get '/lalala' do
    raise "Yo"
  end
end

class VisitStory < Story
  test "Pages should not have errors" do
    Main.seed :sample

    # Always do this in rack_test -- no need to do this in a real browser.
    # We're just here to verify that these URLs don't throw errors or
    # do anything funny.
    s = Capybara::Session.new(:rack_test, Main)
    s.reset!

    s.visit '/logout'
    s.visit '/login'
    s.fill_in 'username', :with => Main.default_user
    s.fill_in 'password', :with => Main.default_password
    s.click_button 'Login'

    assert_admin '/admin', s
    assert_admin '/admin/settings', s
    assert_admin '/admin/settings/database', s
    assert_admin '/user/me/edit', s
    assert_admin '/user/list', s
    assert_admin '/user/1/edit', s

    assert_front '/home', s
    assert_front '/', s
    assert_front '/about-us', s

    assert_404 '/jigglesphinx', s
    assert_404 '/admin/sodapop', s
  end
end
