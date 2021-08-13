class AddSuperiorToOvertimeApprovals < ActiveRecord::Migration[5.1]
  def change
    add_reference :overtime_approvals, :superior, foreign_key: { to_table: :users }
  end
end
