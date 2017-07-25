class SessionsController < ApplicationController
  def new
    @form = LoginForm.new
  end

  def create
    @form = LoginForm.new(login_form_params)
    if user = @form.authenticate
      log_in user
      path = session.delete(:after_login_path) || root_path
      redirect_to path, notice: 'ログインしました。'
    else
      @failure = true
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
end
