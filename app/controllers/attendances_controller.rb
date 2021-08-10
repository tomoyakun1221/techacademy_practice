class AttendancesController < ApplicationController
  
  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    @work_time = @attendance.start_time - @attendance.end_time
    
    if @attendance.start_time.nil?
      if @attendance.update_attributes(start_time: Time.current.change(sec: 0))
        flash[:info] = "おはようございます！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.end_time.nil?
      if @attendance.update_attributes(end_time: Time.current.change(sec: 0))
        flash[:info] = "お疲れさまでした。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to @user
  end
end