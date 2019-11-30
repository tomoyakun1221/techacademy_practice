class AddDecisionToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :decision, :integer
  end
end
