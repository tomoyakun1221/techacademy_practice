class SessionController < ApplicationController
  
  include SessionHelper
    
  def new
  end
  
  def create
    uid = params[:session][:uid]
    password = params[:session][:password]
    remember_me = params[:session][:remember_me]
    
    @user = User.find_by(uid: uid)
    
    if @user && @user.authenticate(password)
      log_in(@user)
      if remember_me == 1
        remember(@user)
      end
      flash[:success] = 'ログインしました。'
      redirect_to root_url
    else
      flash[:danger] = 'ログインに失敗しました。'
      store_location
      redirect_back_or(root_url)
    end
  end
  
  def destroy
    log_out
    flash[:success] = 'ログアウトしました。'
    redirect_to root_url
  end
  
end
