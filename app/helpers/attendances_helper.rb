module AttendancesHelper
  def worked_time(start, finish)
    format("%.2f", (((finish - start) / 60 ) / 60.0))
  end
  
  def overtime_worked_time(start, finish)
    format("%.2f", (((finish - start) / 60 ) / 60.0) - 8 )
  end
  
  def tomorrow_time(start, finish)
    format("%.2f", (((finish - start) / 60) / 60.0) + 24)
  end

  def attendances_invalid?
    attendances = true
    attendances_params.each do |id, item|
      if item[:started_at].blank? && item[:finished_at].blank?
        next
      elsif item[:started_at].blank? || item[:finished_at].blank?
        attendances = false
        break
      elsif item[:started_at] > item[:finished_at] && item[:over_next_day_attendance_change] == "false"  
        attendances = false
        break
      end
    end
    return attendances
  end
end