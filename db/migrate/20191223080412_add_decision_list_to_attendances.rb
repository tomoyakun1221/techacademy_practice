class AddDecisionListToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :decision_attendance_change, :string
    add_column :attendances, :decision_month_order, :string
  end
end
