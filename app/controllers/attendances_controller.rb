class AttendancesController < ApplicationController
  include AttendancesHelper
  
  before_action :set_user, only: [:edit_one_month, :update_one_month, :working_employee_list, :current_month_status, :overtime_application, :overtime_application_notice, :update_overtime_application_notice, :attendance_change_application_notice, :update_attendance_change_application_notice, :one_month_application_notice, :update_one_month_application_notice, :log]
  before_action :logged_in_user, only: [:update, :edit_one_month, :overtime_application, :overtime_application_notice, :update_overtime_application_notice, :attendance_change_application_notice, :update_attendance_change_application_notice, :one_month_application_notice, :update_one_month_application_notice, :log]
  before_action :admin_or_correct_user,  only: [:update, :edit_one_month, :update_one_month]
  before_action :set_one_month, only: :edit_one_month
  

  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。再度登録をお願いします。"
  
  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    if @attendance.started_at.nil?
      if @attendance.update_attributes(started_at: Time.current.change(sec:0))
        flash[:success] = "おはようございます！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
      redirect_to user_url(@user)
    elsif @attendance.started_at.present? && @attendance.finished_at.nil?
      if @attendance.update_attributes(finished_at: Time.current.change(sec:0))
        flash[:success] = "お疲れ様でした。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
      redirect_to user_url(@user)
    end
  end
  
  def edit_one_month
  end
  
  def update_one_month
    if attendances_invalid?
      attendances_params.each do |id, item|
        attendance = Attendance.find(id)
        attendance.update_attributes(item)
      end
      flash[:success] = "勤怠更新に成功しました(指示者確認㊞を選択していない場合は、上長への申請が出来ていません)。"
      redirect_to user_url(@user)
    else
      flash[:danger] = "不正な時間入力がありました。再度ご確認ください。"
      redirect_to attendances_edit_one_month_user_url(@user, params[:date])
    end
  end
  
  #残業申請モーダル
  def overtime_application_info
    @attendance = Attendance.find(params[:id])
    @user = User.find(@attendance.user_id)
  end
  
  #残業申請更新
  def overtime_application
    @attendance = @user.attendances.find_by(worked_on: params[:attendance][:day])
    if params[:attendance][:over_next_day] == "false"
      flash[:warning] = "翌日(24:00以降)まで勤務されているにも関わらず、「翌日」にチェックが入っていなかった場合、再度ご確認ください。"
    end
    
    if params[:attendance][:endplans_time].blank?  || params[:attendance][:business_outline].blank?
      flash[:danger] = "必須箇所が空欄または指示者確認㊞が選択されていません。"
    else
      @attendance.update_attributes(update_overtime_params)
      flash[:success] = "残業申請が完了しました。"
    end
    redirect_to @user
  end
  
  #勤怠変更申請のお知らせモーダル
  def attendance_change_application_notice
  end
  
  #勤怠変更申請のお知らせ表示時の更新処理
  def update_attendance_change_application_notice
    update_attendance_change_application_notice_params.each do |id, item|
      if item[:decision_attendance_change] == "なし" && item[:agreement] == "true"
        attendance = Attendance.find(id)
        attendance.update_attributes(item)
      elsif item[:decision_attendance_change] == "申請中" && item[:agreement] == "true"
        attendance = Attendance.find(id)
        attendance.update_attributes(item)
      elsif item[:decision_attendance_change] == "承認" && item[:agreement] == "true"
        attendance = Attendance.find(id)
        attendance.update_attributes(decision_attendance_change: item[:decision_attendance_change],
                                     started_at: attendance.started_at_after,
                                     finished_at: attendance.finished_at_after,
                                     attendance_change_order_id: item[:attendance_change_order_id],
                                     attendance_change_order_status: current_user.name)
      elsif item[:decision_attendance_change] == "否認" && item[:agreement] == "true"
        attendance = Attendance.find(id)
        attendance.update_attributes(decision_attendance_change: item[:decision_attendance_change],
                                     started_at_after: nil,
                                     finished_at_after: nil,
                                     over_next_day_attendance_change: false,
                                     note: nil,
                                     attendance_change_order_id: item[:attendance_change_order_id],
                                     attendance_change_order_status: current_user.name)
      else
        flash[:danger] = "「変更」にチェックされていないため反映できません。"
      end
      if item[:agreement] == "true"
        flash[:success] = "勤怠情報が変更されました"
      end
    end
    redirect_to @user
  end
  
  #残業申請のお知らせモーダル
  def overtime_application_notice
  end
  
  #残業申請のお知らせ表示時の更新処理
  def update_overtime_application_notice
    update_overtime_notice_params.each do |id, item|
      if item[:decision] == "なし" && item[:agreement] == "true"
        attendance = Attendance.find(id)
        attendance.update_attributes(item)
      elsif item[:decision] == "申請中" && item[:agreement] == "true"
        attendance = Attendance.find(id)
        attendance.update_attributes(item)
      elsif item[:decision] == "承認" && item[:agreement] == "true"
        attendance = Attendance.find(id)
        attendance.update_attributes(decision: item[:decision],
                                     overtime_order_id: item[:overtime_order_id],
                                     overtime_order_status: current_user.name)
      elsif item[:decision] == "否認" && item[:agreement] == "true"
        attendance = Attendance.find(id)
        attendance.update_attributes(decision: item[:decision],
                                     endplans_time: nil,
                                     over_next_day: false,
                                     business_outline: nil,
                                     overtime_order_id: item[:overtime_order_id],
                                     overtime_order_status: current_user.name)
      else
        flash[:danger] = "「変更」にチェックされていないため反映できません。"
      end
      if item[:agreement] == "true"
        flash[:success] = "残業情報が変更されました。"
      end
    end
    redirect_to @user
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
  
  #1ヶ月分の勤怠申請のお知らせのモーダル表示
  def one_month_application_notice
  end
  
  #1ヶ月分の勤怠申請のお知らせ表示時の更新処理
  def update_one_month_application_notice
    update_one_month_notice_params.each do |id, item|
      if item[:decision_month_order] == "なし" && item[:agreement] == "true"
        attendance = Attendance.find(id)
        attendance.update_attributes(item)
      elsif item[:decision_month_order] == "申請中" && item[:agreement] == "true"
        attendance = Attendance.find(id)
        attendance.update_attributes(item)
      elsif item[:decision_month_order] == "承認" && item[:agreement] == "true"
        attendance = Attendance.find(id)
        attendance.update_attributes(decision_month_order: item[:decision_month_order],
                                     month_order_id: item[:month_order_id],
                                     month_order_status: current_user.name)
      elsif item[:decision_month_order] == "否認" && item[:agreement] == "true"
        attendance = Attendance.find(id)
        attendance.update_attributes(decision_month_order: item[:decision_month_order],
                                     month_order_id: item[:month_order_id],
                                     month_order_status: current_user.name)
      else
        flash[:danger] = "「変更」にチェックされていないため反映できません。"
      end
      if item[:agreement] == "true"
        flash[:success] = "１ヶ月分の勤怠情報を更新しました。"
      end
    end
    redirect_to @user
  end
  
  #勤怠ログ
  def log
    #ユーザーに紐づく全ての勤怠情報が取得できる
    @attendances = @user.attendances.where(decision_attendance_change: "承認")
    pp @attendances
  end
  
  private
  
  # 1ヶ月分の勤怠情報を扱います。
  def attendances_params
    params.require(:user).permit(attendances: [:started_at_after, :finished_at_after, :note, :over_next_day, :over_next_day_attendance_change, :attendance_change_order_id, :decision_attendance_change])[:attendances]
  end
  
  #残業申請更新
  def update_overtime_params
    params.require(:attendance).permit(:endplans_time, :over_next_day, :business_outline, :overtime_order_id, :decision)
  end
  
  #残業申請お知らせ時の更新
  def update_overtime_notice_params
    params.require(:user).permit(attendances: [:decision, :agreement])[:attendances]
  end
  
  #勤怠変更申請のお知らせの更新
  def update_attendance_change_application_notice_params
    params.require(:user).permit(attendances: [:decision_attendance_change, :agreement])[:attendances]
  end
  
  #１ヶ月分の勤怠申請のお知らせの更新
  def update_one_month_notice_params
    params.require(:user).permit(attendances: [:decision_month_order, :agreement])[:attendances]
  end
    
  # 管理権限者、または現在ログインしているユーザーを許可します。
  def admin_or_correct_user
    @user = User.find(params[:user_id]) if @user.blank? 
    unless current_user.admin? || current_user?(@user)
      flash[:danger] = "編集・操作権限がありません"
      redirect_to root_url
    end
  end
end