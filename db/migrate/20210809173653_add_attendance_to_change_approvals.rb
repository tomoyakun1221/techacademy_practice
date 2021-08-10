class AddAttendanceToChangeApprovals < ActiveRecord::Migration[5.1]
  def change
    add_reference :change_approvals, :attendance, foreign_key: true
  end
end
