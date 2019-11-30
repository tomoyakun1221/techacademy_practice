class AddOneMonthToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :month_order_superior_status, :string
    add_column :attendances, :month_order_superior_id, :string
    add_column :attendances, :agreement, :boolean
  end
end
