module SessionsHelper
  def login(user)
    session[:user_id] = user.id
  end

  def current_user
    if (user_id = session[:user_id])
      return @current_user ||= User.find_by(id: user_id)
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
    reset_session
    forget(current_user)
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
end
