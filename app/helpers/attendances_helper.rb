require 'rounding'

module AttendancesHelper
  def worked_time(start, finish)
    format("%.2f", (((finish - start) / 60 )/ 60.0) )
  end
  
  def attendances_invalid?
    attendances = true
    attendances_params.each do |id, item|
      if item[:start_time].blank? && item[:end_time].blank?
        next
      elsif item[:start_time].blank? || item[:end_time].blank?
        attendances = false
        break
      elsif item[:start_time] > item[:end_time]  
        attendances = false
        break
      end
    end
    return attendances
  end
end
