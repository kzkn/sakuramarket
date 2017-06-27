# -*- coding: utf-8 -*-
class SignupController < ApplicationController
  def show
    @signup = Form::Signup.new
  end

  def create
    @signup = Form::Signup.new(signup_params)

    respond_to do |format|
      if @signup.register
        format.html { redirect_to login_path, notice: "登録しました。" }
      else
        format.html { render :show }
      end
    end
  end

  private
  def signup_params
    params.require(:form_signup).permit(:email_address, :password,
      :delivery_destination_name, :delivery_destination_address)
  end
end
