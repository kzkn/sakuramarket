class SessionsController < ApplicationController
  before_action :set_redirect_to, only: %i(new create)

  def new
    @form = LoginForm.new
  end

  def create
    @form = LoginForm.new(login_form_params)
    if user = @form.authenticate
      log_in user
      redirect_to @redirect_to, notice: 'ログインしました。'
    else
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_path, notice: 'ログアウトしました。'
  end

  private
  def login_form_params
    params.require(:login_form).permit(:email, :password)
  end

  def set_redirect_to
    @redirect_to = acceptable_location(params[:redirect_to]) || root_path
  end

  def acceptable_location(location)
    pattern = %r(\A#{root_url})
    pattern.match(location) && location
  end
end
