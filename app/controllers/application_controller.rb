class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :require_login
  before_action :new_comments
  
  def current_user
    User.find_by_id(session[:user_id])
  end
  
  def logged_in?
    !current_user.nil?
  end
  
  def require_login
    unless logged_in?
      flash[:error] = "You mast be logged in"
      redirect_to login_path
    end
  end
  
  def new_comments
    @new_comments = Comment.where(published: false) if logged_in?
  end
end
