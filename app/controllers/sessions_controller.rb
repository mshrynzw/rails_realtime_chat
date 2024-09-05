class SessionsController < ApplicationController
  def new
    redirect_to messages_path if logged_in?
  end

  def create
    user = Back4App.login(params[:username], params[:password])
    if user
      session[:user_id] = user['objectId']
      session[:username] = user['username']
      redirect_to messages_path, notice: 'ログインしました'
    else
      flash.now[:alert] = 'ユーザー名またはパスワードが違います'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    session[:username] = nil
    redirect_to login_path, notice: 'ログアウトしました'
  end
end