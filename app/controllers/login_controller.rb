# -*- coding: utf-8 -*-
class LoginController < ApplicationController
  def show
    @login = Login.new
  end

  def create
    @login = Login.new(login_params)

    respond_to do |format|
      if user = @login.user
        authenticated user
        format.html { redirect_to root_path, notice: "ログインしました。" }
      else
        flash[:notice] = "ログインに失敗しました。"
        format.html { render :show }
      end
    end
  end

  private
  def login_params
    params.require(:login).permit(:account, :password)
  end
end
