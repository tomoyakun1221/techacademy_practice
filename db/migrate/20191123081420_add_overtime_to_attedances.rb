class AddOvertimeToAttedances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :overtime_order_id, :string
    add_column :attendances, :overtime_order_status, :string
  end
end
