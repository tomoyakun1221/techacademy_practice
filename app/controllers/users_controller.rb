class UsersController < ApplicationController
  
  def index
    @user = User.all
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to root_url
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = 'ユーザー情報の更新に成功しました。'
      redirect_to root_url
    else
      flash.now[:danger] = 'ユーザー情報の更新に失敗しました。'
      render 'edit'
    end
  end
  
  private

  def user_params
    params.require(:user).permit(:name, :uid, :password, :password_confirmation, :role)
  end
end
