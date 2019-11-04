class RemoveOneMonthFromAttendances < ActiveRecord::Migration[5.1]
  def change
    remove_column :attendances, :month_order_status, :string
    remove_column :attendances, :month_order_id, :string
    remove_column :attendances, :agreement, :boolean
  end
end
