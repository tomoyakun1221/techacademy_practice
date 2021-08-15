class ChangeApprovalsController < ApplicationController
  
 def attendance_change_application_notice
    @user = User.find(params[:user_id])
    @change_applications = ChangeApproval.where(superior_id: @user.id, application_situation: 0)
    render 'attendances/attendance_change_application_notice.js.erb'
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
  
  
  def approve_or_reject_params
    params.require(:change_approval).permit(:checked, :application_situation)
  end
end
