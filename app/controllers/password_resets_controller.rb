class PasswordResetsController < ApplicationController
  
  def new
  end
  
  def create
    uid = params[:password_resets][:uid]
    @user = User.find_by(uid: uid)
    
    if @user
      session[:uid] = uid
      redirect_to edit_password_reset_path(@user.id)
    else
      flash.now[:danger] = '職員コードが存在しません。'
      render :new
    end
  end
  
  def edit
    @user = User.find(params[:id])
    
    if @user && (@user.uid == session[:uid])
      session.delete(:uid)
      return @user
    else
      session.delete(:uid)
      flash.now[:danger] = '職員コードを入力してください。'
      render :new
    end
    
  end
  
  def update
    @user = User.find(params[:id])
    password_params = params.permit(:password, :password_confirmation)
    
    if @user.update(password_params)
      flash[:success] = 'パスワードを変更しました。'
      redirect_to login_path
    else
      flash.now[:danger] = 'パスワードの変更に失敗しました。'
      render :edit
    end
  end
end
