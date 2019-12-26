class RemoveMonthOrderSuperiorListFromAttendances < ActiveRecord::Migration[5.1]
  def change
    remove_column :attendances, :month_order_superior_status, :string
    remove_column :attendances, :month_order_superior_id, :string
  end
end
