class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :logged_in_user, only: [:index, :show, :edit, :update]
  before_action :correct_user, only: [:edit, :update]
  
  def new
    @user = User.new
  end
  
  def show
  end
  
  def index
    @users = User.paginate(page: params[:page], per_page: 20)
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "ユーザーの新規作成に成功しました"
      redirect_to @user
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザーの更新に成功しました"
      redirect_to @user
    else
      render :edit
    end
  end
  
  private
    
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    #logged_userで@user(インスタンス変数)で定義しており、さらにshow.edit.updateで@userを定義するのはくどいので、set_userで設定する
    def set_user
      @user = User.find(params[:id])
    end
    
    #編集.更新.障害画面閲覧はログインしているユーザーのみ可能にするための判定
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインして下さい"
        redirect_to login_url
      end
    end
    
    #編集.更新は、現在ログインしているユーザーのみ可能にするための判定
    def correct_user
      @user = User.find(params[:id])
      redirect_to root_url unless current_user?(@user) 
    end
end
