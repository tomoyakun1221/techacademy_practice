class AddAttendanceChangeOrderIdToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :attendance_change_order_id, :string
  end
end
