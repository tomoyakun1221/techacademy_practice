class UsersController < ApplicationController
  include UsersHelper
  
  before_action :set_user, only: [:show, :show_only, :edit, :update, :destroy, :edit_basic_info, :update_basic_info, :edit_one_month, :send_posts_csv, :current_month_status, :one_month_application_notice, :update_one_month_application, :overtime_application_notice, :custom_parse]
  before_action :logged_in_user, only: [:show, :index, :edit, :update, :destroy, :edit_basic_info, :update_basic_info, :edit_one_month, :one_month_application_notice, :update_one_month_application]
  before_action :correct_user, only: [:show, :edit, :update]
  before_action :admin_user, only: [:index, :destroy, :edit_basic_info, :update_basic_info, :edit_one_month, :working_employee_list, :basic_info_edit]
  before_action :admin_or_correct_user, only: [:show]
  before_action :set_one_month, only: [:show, :show_only]
  
  def index
    @users = User.paginate(page: params[:page])
    if params[:name].present?
      @users = @users.get_by_name params[:name]
    end
  end
  
  def show_only
    @worked_sum = @attendances.where.not(started_at: nil, finished_at: nil).count
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

  def working_employee_list
    @attendances = Attendance.all.includes(:user)
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
  
  #１ヶ月分の勤怠申請更新
  def update_one_month_application
    day = params[:date]
    @attendance = @user.attendances.find_by(worked_on: day)
    unless params[:attendance][:month_order_id].empty?
      @attendance.update_attributes(update_one_month_application_params)
      flash[:success] = "１ヶ月分の勤怠を申請をしました。#{@attendance.month_order_id}の承認をお待ち下さい。"
    else
      flash[:danger] = "所属長を選択してください。"
    end
    redirect_to @user
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :department, :password, :password_confirmation)
    end
    
    #1ヶ月分の勤怠申請の通知をします
    def update_one_month_application_params
      params.require(:attendance).permit(:month_order_id, :decision_month_order)
    end

    def basic_info_params
      params.require(:user).permit(:name, :email, :department, :employee_number, :user_card_id, :basic_time, :work_time, :user_designated_work_start_time, :user_designated_work_end_time)
    end
end