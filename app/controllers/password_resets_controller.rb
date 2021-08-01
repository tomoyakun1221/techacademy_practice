class PasswordResetsController < ApplicationController
  
  def new
  end
  
  def create
    uid = params[:password_resets][:uid]
    @user = User.find_by(uid: uid)
    
    if @user
      redirect_to edit_password_reset_path(@user.id)
    else
      flash.now[:danger] = '職員コードが存在しません。'
      render :new
    end
  end
  
  def edit
    
  end
  
  
end
