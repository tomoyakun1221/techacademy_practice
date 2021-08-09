class AttendancesController < ApplicationController
  def create
    @attendance = Attendance.new
    if @attendance.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to user_path(current_user)
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      rsdirect_to root_path
    end
  end
end
