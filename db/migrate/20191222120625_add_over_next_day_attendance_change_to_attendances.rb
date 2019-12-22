class AddOverNextDayAttendanceChangeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :over_next_day_attendance_change, :boolean
  end
end
