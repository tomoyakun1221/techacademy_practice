module AttendancesHelper
  def worked_time(start, finish)
    format("%.2f", (((finish - start) / 60 ) / 60.0))
  end
  
  def overtime_worked_time(start, finish)
    format("%.2f", (((finish - start) / 60 ) / 60.0) - 8 )
  end
  
  def tomorrow_time(start, finish)
    format("%.2f", (((attendance.finished_at - attendance.started_at) / 60) / 60.0) + 24)
  end
  
  def endplans_time_minus_user_designated_work_end_time(start, finish)
    format("%.2f", (((finish - start) / 60 ) / 60.0))
  end

  def attendances_invalid?
    attendances = true
    attendances_params.each do |id, item|
      if item[:started_at].blank? && item[:finished_at].blank?
        next
      elsif item[:started_at].blank? || item[:finished_at].blank?
        attendances = false
        break
      elsif item[:started_at] > item[:finished_at]
        attendances = false
        break
      end
    end
    return attendances
  end
  
  #残業申請のあった人からのチェックロジック
  def attendance_check
    @users = User.all
    pp @users
    @users.each do |user| 
      @attendances = Attendance.where(user_id: user.id) 
      pp @attendances
      @attendances.each do |attendance|
        at = true
        if attendance.overtime_order_id.present? && attendance.overtime_order_id.to_i == user.id
          next
        else
          at = false
        end
        return at
      end
    end
  end
end