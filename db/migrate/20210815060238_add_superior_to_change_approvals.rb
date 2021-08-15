class AddSuperiorToChangeApprovals < ActiveRecord::Migration[5.1]
  def change
    add_reference :change_approvals, :superior, foreign_key: { to_table: :users }
  end
end
