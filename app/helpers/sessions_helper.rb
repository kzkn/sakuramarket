module SessionsHelper
  def current_user
    @user ||= User.find_by(id: session[:user_id])
  end

  def is_signed_in?
    current_user.present?
  end

  def is_admin?
    current_user&.admin
  end
end
