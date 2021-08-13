class RemoveAttendenceToOvertimeApprovals < ActiveRecord::Migration[5.1]
  def change
    remove_reference :overtime_approvals, :attendence, foreign_key: true
  end
end
