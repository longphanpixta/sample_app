class SessionsController < ApplicationController
  def new; end

  def create
    login_params = params[:session]
    user = User.find_by email: login_params[:email]

    if user&.authenticate(login_params[:password])
      reset_session
      login user
      redirect_to user

    else
      flash[:danger] = t('.invalid_user')
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_url, status: :see_other
  end
end
