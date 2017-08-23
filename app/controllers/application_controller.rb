class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :is_signed_in?, :is_admin?

  def current_user
    @user ||= User.find_by(id: session[:user_id])
  end

  def is_signed_in?
    current_user.present?
  end

  def is_admin?
    current_user&.admin
  end

  def authenticate!
    unless is_signed_in?
      redirect_to_login
    end
  end

  def authenticate_admin!
    unless is_admin?
      redirect_to root_path, alert: '権限がありません。'
    end
  end

  def redirect_to_login
    redirect_to login_path(redirect_to: request.url)
  end

  def log_in(user)
    session[:user_id] = user.id
    current_cart&.merge_or_assign(user)&.tap do |cart|
      set_current_cart cart
    end
  end

  def log_out
    unset_current_cart
    session.delete(:user_id)
    @user = nil
  end

  def current_cart
    @cart ||= Order.find_by(id: session[:cart_id])
  end

  def set_current_cart(cart)
    session[:cart_id] = cart.id
  end

  def unset_current_cart
    session.delete(:cart_id)
    @cart = nil
  end

  def ensure_cart_created
    Order.ensure_cart_created(current_cart, current_user).tap do |cart|
      set_current_cart cart
    end
  end
end
