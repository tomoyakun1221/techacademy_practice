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
      if item[:started_at_after].blank? && item[:finished_at_after].blank?
        next
      elsif item[:started_at_after].blank? || item[:finished_at_after].blank?
        attendances = false
        break
      elsif item[:started_at_after] > item[:finished_at_after] && item[:over_next_day_attendance_change] == "false"  
        attendances = false
        break
      end
    end
    return attendances
  end
end