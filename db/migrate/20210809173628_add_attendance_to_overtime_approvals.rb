class AddAttendanceToOvertimeApprovals < ActiveRecord::Migration[5.1]
  def change
    add_reference :overtime_approvals, :attendance, foreign_key: true
  end
end
