class OvertimeApprovalsController < ApplicationController

  def new
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:attendance_id])
    superiors = User.where.not(id: @user.id).superior
    @superiors = {}
    superiors.each do |superior|
      @superiors[superior.name] = superior.id
    end
    if @attendance.overtime_approval
      @overtime_approval = @attendance.overtime_approval
    else
      @overtime_approval = @attendance.build_overtime_approval(user_id: @user.id)
    end
    render 'attendances/overtime_application_info'
  end

  def create
    @overtime_approval = Attendance.find(params[:attendance_id]).overtime_approval
    @user = User.find(params[:user_id])
    if Attendance.find(params[:attendance_id]).create_overtime_approval(overtime_approval_params)
      flash[:info] = "翌日（24:00以降）まで勤務されているにも関わらず、「翌日」にチェックが入っていなかった場合、再度ご確認ください。"
      flash[:success] = "残業申請が完了しました。"
      redirect_to @user
    else
      flash.now[:danger] = "残業申請に失敗しました。"
      render :new
    end  
  end

  def overtime_application_notice
    @user = User.find(params[:user_id])
    @overtime_applications = OvertimeApproval.where(superior_id: @user.id, application_situation: 0)
    render 'attendances/overtime_application_notice.js.erb'
  end

  def update
    @overtime_approval = Attendance.find(params[:attendance_id]).overtime_approval
    @user = User.find(params[:user_id])
    if @overtime_approval.update(overtime_approval_params)
      flash[:info] = "翌日（24:00以降）まで勤務されているにも関わらず、「翌日」にチェックが入っていなかった場合、再度ご確認ください。"
      flash[:success] = "残業申請が完了しました。"
      redirect_to @user
    else  
      flash.now[:danger] = "残業申請に失敗しました。"
      render :new
    end
  end

  def approve_or_reject
    @overtime_approval = OvertimeApproval.find(params[:id])
    if approve_or_reject_params[:checked] == "1"
      if @overtime_approval.update(application_situation: approve_or_reject_params[:application_situation].to_i)
        if @overtime_approval.approval?
          flash[:success] = "残業を承認しました。"
        elsif @overtime_approval.rejection?
          flash[:success] = "残業を否認しました。"
        end
        redirect_to current_user
      else  
        flash.now[:danger] = "残業申請の更新に失敗しました。"
        render :new
      end
    else
      redirect_to current_user
    end
  end

  private

  def overtime_approval_params
    params[:overtime_approval][:user_id] = params[:user_id]
    if params[:overtime_approval][:superior_id]
      params[:overtime_approval][:application_situation] = 0
    end
    params.require(:overtime_approval).permit(:end_time, :nextday_flag, :comment, :application_situation, :user_id, :superior_id)
  end

  def approve_or_reject_params
    params.require(:overtime_approval).permit(:checked, :application_situation)
  end

end
