class UsersController < ApplicationController

  def new
    @form = SignupForm.new
  end

  def create
    @form = SignupForm.new(signup_params)

    if @form.create_user
      redirect_to login_path, notice: '登録しました。'
    else
      render :new
    end
  end

  private
  def signup_params
    params.require(:signup_form).permit(:email, :password, :password_confirmation)
  end
end
