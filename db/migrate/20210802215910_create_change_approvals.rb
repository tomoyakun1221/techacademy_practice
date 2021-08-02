class CreateChangeApprovals < ActiveRecord::Migration[5.1]
  def change
    create_table :change_approvals do |t|
      t.time :start_time
      t.time :end_time
      t.text :comment
      t.integer :application_situation

      t.timestamps
    end
  end
end
