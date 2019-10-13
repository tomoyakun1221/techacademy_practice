class AttendancesController < ApplicationController
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
end
