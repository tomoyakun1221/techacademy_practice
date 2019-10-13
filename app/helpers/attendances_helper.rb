module AttendancesHelper
  def worked_time(start, finish)
    format("%.2f", (((finish - start) / 60.0 ) / 60.0))
  end
end
