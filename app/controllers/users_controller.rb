class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info]
  
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
  
  def destroy
    @user.destroy
    flash[:danger] = "削除されました"
    redirect_to users_url
  end
  
  def edit_basic_info
  end
  
  def update_basic_info
    if @user.update_attributes(basic_info_params)
      flash[:success] = "#{@user.name}の更新が成功しました"
    else
      flash[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end
  
  private
    
    def user_params
      params.require(:user).permit(:name, :email, :department, :password, :password_confirmation)
    end
    
    def basic_info_params
      params.require(:user).permit(:department, :basic_time, :work_time)
    end
    
    #logged_userで@user(インスタンス変数)で定義しており、さらにshow.edit.updateで@userを定義するのはくどいので、set_userで設定する
    def set_user
      @user = User.find(params[:id])
    end
    
    #編集.更新.詳細.削除画面閲覧はログインしているユーザーのみ可能にするための判定
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
    
    def admin_user
      redirect_to root_url unless current_user.admin?
    end
end
