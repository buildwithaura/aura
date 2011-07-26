class Main
  module UserHelpers
    def logged_in?
      !! current_user
    end

    def current_user
      authenticated(Aura::Models::User)
    end

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
