module AttendancesHelper
  def worked_time(start, finish)
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
  
   # 所属長承認の表示
  def current_month_status(day)
    @attendance = @user.attendances.find_by(worked_on: day)
    name = User.superior_user_except_myself(session).map { |name| name[:name] }
    if name.index(@attendance.month_order_superior_id)
      "#{@attendance.month_order_superior_id}に申請中"
    elsif @attendance.decision == 2
      "#{@attendance.month_order_superior_id}から承認済"
    elsif @attendance.decision == 3
      "#{@attendance.month_order_superior_id}から否認"
    else
      "未"
    end
  end
end