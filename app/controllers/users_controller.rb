class UsersController < ApplicationController
  include UsersHelper
  
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info, :edit_one_month, :send_posts_csv, :current_month_status, :one_month_application_info, :overtime_application_info]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :edit_basic_info, :update_basic_info, :edit_one_month]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info, :edit_one_month]
  before_action :set_one_month, only: :show

  def index
    @users = User.paginate(page: params[:page])
    if params[:name].present?
      @users = @users.get_by_name params[:name]
    end
  end

  def show
    @worked_sum = @attendances.where.not(started_at: nil, finished_at: nil).count
    
    respond_to do |format|
      format.all
      format.csv do |csv|
        send_posts_csv(@attendances)
      end
    end
  end
  
  def send_posts_csv(attendances)
    csv_data = CSV.generate do |csv|
      header = %w(日付 出社時間 退社時間 備考)
      csv << header

      attendances.each do |day|
        values = [l(day.worked_on, format: :short),
                  if day.started_at.nil?
                    day.started_at
                  else
                    l(day.started_at, format: :time)
                  end,
                  if day.finished_at.nil?
                    day.finished_at
                  else
                    l(day.finished_at, format: :time)
                  end, 
                  day.note]
        csv << values
      end
    end
    send_data(csv_data, filename: "#{@user.name}の勤怠情報.csv")
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render :edit      
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end

  def edit_basic_info
  end

  def update_basic_info
    if @user.update_attributes(basic_info_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
    else
      flash[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end
  
  #1ヶ月分の勤怠申請
  def one_month_application_info
    @first_day = params[:date].nil? ? Date.current.beginning_of_month : params[:date].to_date
    @title_name = Attendance.joins(:user).where(month_order_id: current_user.name)
  end
  
  #残業申請
  def overtime_application_info
    @attendance = Attendance.find(params[:id])
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :department, :password, :password_confirmation)
    end

    def basic_info_params
      params.require(:user).permit(:name, :email, :department, :employee_number, :user_card_id, :basic_time, :work_time, :user_designated_work_start_time, :user_designated_work_end_time)
    end
end