require 'rounding'

module AttendancesHelper
  def worked_time(start, finish)
    format("%.2f", (((finish - start).ceil_to(15.minutes) / 60 )/ 60.0) )
  end
end
