require 'rounding'

module AttendancesHelper
  def worked_time(start, finish)
    format("%.2f", (((finish - start) / 60 )/ 60.0) )
  end
end
