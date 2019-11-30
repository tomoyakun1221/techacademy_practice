class AddOneMonthExceptSuperiorToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :month_order_status, :string
    add_column :attendances, :month_order_id, :string
  end
end
