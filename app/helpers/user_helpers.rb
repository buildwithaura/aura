class Main
  module UserHelpers
    # User helpers: logged_in? (Helpers)
    # Checks if there is a user logged in or not.
    #
    def logged_in?
      !! current_user
    end

    # User helpers: current_user (Helpers)
    # Returns the current user as an instance of {Aura::Models::User}.
    #
    def current_user
      authenticated(Aura::Models::User)
    end

    # User helpers: require_login (Helpers)
    # Ensures that a route is only accessible to logged in users.
    #
    def require_login
      redirect R(:login)  unless logged_in?
    end

    # Overridden in aura to track last login time.
    # This is called when a user logs in.
    #
    def redirect_to_return_url(session_key = :return_to, default = '/admin')
      u = current_user
      first_login = u.last_login.nil?

      u.last_login = Time.now
      u.save

      # On a user's first login, go to a admin welcome page
      # where they can change their password.
      if first_login
        redirect R(:admin, :welcome)
      end

      redirect session.delete(:return_to) || default
    end
  end

  helpers UserHelpers
end
