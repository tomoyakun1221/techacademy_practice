class ChangeApprovalsController < ApplicationController
  before_action :set_user, only: [:update]
  before_action :set_one_month, only: [:update]
  before_action :logged_in_user, only: [:update]
  before_action :admin_or_correct_user, only: [:update]
  
 def attendance_change_application_notice
    @user = User.find(params[:user_id])
    @change_applications = ChangeApproval.where(superior_id: @user.id, application_situation: 0)
    render 'attendances/attendance_change_application_notice.js.erb'
 end
  
  def update
    @change_approval = Attendance.find(params[:attendance_id]).change_approval
    if @change_approval.update(change_approval_params)
      flash[:info] = "勤怠更新に成功しました(指示者確認㊞を選択していない場合は、上長への申請が出来ていません)。"
      redirect_to @user
    else  
      flash.now[:danger] = "不正な時間入力がありました。再度ご確認ください。"
      render :new
    end
  end
  
  def approve_or_reject
    @change_approval = ChangeApproval.find(params[:id])
    if approve_or_reject_params[:checked] == "1"
      if @change_approval.update(application_situation: approve_or_reject_params[:application_situation].to_i)
        if @change_approval.approval?
          flash[:success] = "勤怠変更を承認しました。"
        elsif @change_approval.rejection?
          flash[:success] = "勤怠変更を否認しました。"
        end
        redirect_to current_user
      else  
        flash.now[:danger] = "勤怠変更申請の更新に失敗しました。"
        render :new
      end
    else
      redirect_to current_user
    end
  end
  
  private
  
  def set_user
    @user = User.find(params[:user_id])
  end
  
  def approve_or_reject_params
    params.require(:change_approval).permit(:checked, :application_situation)
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
