class CreateOvertimeApprovals < ActiveRecord::Migration[5.1]
  def change
    create_table :overtime_approvals do |t|
      t.references :user, foreign_key: true
      t.references :attendence, foreign_key: true
      t.time :end_time
      t.boolean :nextday_flag
      t.integer :application_situation
      t.text :comment

      t.timestamps
    end
  end
end
