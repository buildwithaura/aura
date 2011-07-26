require File.expand_path('../test_helper', __FILE__)

require "capybara"
require "capybara/dsl"

Capybara.app = Main

if ENV['driver'] == 'chrome'
  Capybara.default_driver = (ENV['driver'] || :chrome).to_sym
  Capybara.register_driver :chrome do |app|
    Capybara::Driver::Selenium.new(app, :browser => :chrome)
  end
end

class Test::Unit::TestCase
  include Capybara

  def status
    p "Current path", current_path
  end

  def assert_location(loc)
    assert_equal loc, current_path
  end

  def login!
    visit '/login'
    if page.has_css?("form[action$=login]")
      fill_in 'username', :with => Main.default_user
      fill_in 'password', :with => Main.default_password
      click_button 'Login'
      save_and_open_page
      assert ! page.has_content?('Login'), 'Login failed.'
    end
  end

  # Checks that the given URL is an admin area.
  def assert_admin(url, session=self)
    session.visit url
    assert ! session.has_content?('Login'), 'Ended up in a login page.'
    assert session.has_content?('Aura')
    assert session.has_css?('#top')
    assert session.has_css?('aside#nav')
  end

  def assert_front(url, session=self)
    session.visit url
    assert ! session.has_content?('Login'), 'Ended up in a login page.'
  end

  def assert_404(url=nil, s=self)
    s.visit url unless url.nil?
    assert (s.has_content?('Not found') || s.has_content?('know this ditty'))
  end
end
