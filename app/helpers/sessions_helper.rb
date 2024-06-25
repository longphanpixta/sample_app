module SessionsHelper
  def login(user)
    session[:user_id] = user.id
    session[:session_token] = user.session_token
  end

  def current_user
    if (user_id = session[:user_id])
      user = User.find_by(id: user_id)

      return @current_user = user if user && session[:session_token] == user.session_token
    end

    return unless (user_id = cookies.encrypted[:user_id])

    user = User.find_by(id: user_id)
    return unless user&.authenticated?(cookies[:remember_token])

    login user
    @current_user = user
  end

  def logged_in?
    !current_user.nil?
  end

  def logout
    forget(current_user)
    reset_session
    @current_user = nil
  end

  def remember(user)
    user.remember

    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget(user)
    user.forget

    cookies.delete :user_id
    cookies.delete :remember_token
  end

  def current_user?(user)
    user && user == current_user
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
