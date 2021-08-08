class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :update_index, :destroy, :show]
  
  def index
    @users = User.all
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
  
  def show
    require "date"
    @first_day = Date.current.beginning_of_month
    @last_day = @first_day.end_of_month
    one_month = [@first_day..@last_day]
    attendance_dates = @user.attendances.where(date: one_month).pluck(:date)

    # 出社のない日があれば、表示用に空データを作成
    one_month.each do |day|
      next if attendance_dates.include?(day)
      @user.attendances.build(date: day)
    end

    # 日付順に並び替える
    @user.attendances.sort_by(&:date)
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = 'ユーザー情報の更新に成功しました。'
      redirect_to root_url
    else
      flash.now[:danger] = 'ユーザー情報の更新に失敗しました。'
      render 'edit'
    end
  end
  
  def update_index
    if @user.update_attributes(user_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
      redirect_to root_url
    else
      flash.now[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
      @users = User.all
      render 'index'
    end
  end
  
  def destroy
    @user.destroy
    flash[:success] = 'ユーザーを削除しました。'
    redirect_back(fallback_location: root_path)
  end

  def working_employee_list
    if current_user.admin?

      @users = Array.new
      working_employee_attendances = Attendance.where(end_time: nil).where.not(start_time: nil)
      
      working_employee_attendances.each do |wea|
        @users.push(wea.user)
      end

    else
      flash[:danger] = "閲覧権限がありません。"
      redirect_to root_url
    end
  end
  
  def import
    if File.extname(params[:file].original_filename) == ".csv"
      flash[:success] = 'CSVファイルを読み込みました'
      User.import(params[:file])
      redirect_to users_url
    else
      flash[:danger] = 'CSVファイルを選択してください'
      @users = User.all
      redirect_to users_url
    end
  end
  
  def register_start_time
    @attendance = current_user.attendances.build
    if @walkcourse.save
      flash[:success] = '時刻が登録されました。'
      redirect_to user_path(@user)
    else
      flash.now[:danger] = '時刻の登録に失敗しました。'
      render 'show'
    end
  end
  
  private

  def user_params
    params.require(:user).permit(:name, :uid, :password, :password_confirmation, :role)
  end
  
  def set_user
    @user = User.find(params[:id])
  end
end
