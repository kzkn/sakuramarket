class ApplicationController < ActionController::Base
  include SessionsHelper

  protect_from_forgery with: :exception

  def authenticate!
    unless current_user
      redirect_to login_path
    end
  end

  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def set_current_cart(cart)
    session[:cart_id] = cart.id
    current_user.try(:cart=, cart)
  end

  def current_cart
    @current_cart ||= Cart.find_by(id: session[:cart_id])
  end

  def current_cart_ensured
    cart = current_cart || Cart.create
    set_current_cart(cart)
    cart
  end
end
