class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def authenticate!
    unless current_user
      redirect_to login_path
    end
  end

  def authenticated(user)
    session[:user_id] = user.try(:id)
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
