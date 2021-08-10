class RemoveAttendenceToChangeApprovals < ActiveRecord::Migration[5.1]
  def change
    remove_reference :change_approvals, :attendence, foreign_key: true
  end
end
