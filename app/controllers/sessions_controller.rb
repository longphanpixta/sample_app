class SessionsController < ApplicationController
  def new; end

  def create
    login_params = params[:session]
    user = User.find_by email: login_params[:email]

    if user&.authenticate(login_params[:password])
      forwarding_url = session[:forwarding_url]
      reset_session
      login_params[:remember_me] == Settings.global.checkbox_true ? remember(user) : forget(user)
      login user
      redirect_to forwarding_url || user

    else
      flash[:danger] = t('.invalid_user')
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout if logged_in?
    redirect_to root_url, status: :see_other
  end
end
