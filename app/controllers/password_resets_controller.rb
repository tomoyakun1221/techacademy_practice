class PasswordResetsController < ApplicationController
  
  before_action :set_user, only: [:edit, :update]

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
    if @user.update(password_params)
      flash[:success] = 'パスワードを変更しました。'
      redirect_to login_path
    else
      flash.now[:danger] = 'パスワードの変更に失敗しました。'
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def password_params
    params.require(:password_reset).permit(:password, :password_confirmation)
  end

end
