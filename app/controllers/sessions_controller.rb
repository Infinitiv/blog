class SessionsController < ApplicationController
  skip_before_action :require_login
  
  def new
  end

  def create
    @latitude = 59
    user = User.find_by_login(params[:login])
    if user and user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path
    else
      redirect_to login_url, alert: "Error"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Logout"
  end
end
