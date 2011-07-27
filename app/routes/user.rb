class Main
  # The user is redirected here on first load.
  get '/admin/welcome' do
    require_login
    @first = true
    show_admin User.templates_for('edit'),
      :item   => current_user,
      :action => current_user.path(:edit),
      :first  => @first
  end

  post '/login' do
    if login(User, params[:username], params[:password])
      redirect_to_return_url

    else
      session[:error] = "Sorry, you must have mistyped something. Try again!"
      redirect R(:login)
    end
  end

  get '/login' do
    redirect R(:admin)  if logged_in?
    if request.xhr?
      return "<div id='redirect'>#{request.fullpath}</div>"
    end

    show 'user/login', :layout => nil
  end

  get '/logout' do
    if logged_in?
      logout(User)
      flash_message "You have logged out."
    end

    redirect R(:login)
  end

  get '/user/me/edit' do
    require_login
    @item = current_user

    show_admin @item.templates_for('edit'),
      :item   => @item,
      :action => @item.path(:edit)
  end
end
