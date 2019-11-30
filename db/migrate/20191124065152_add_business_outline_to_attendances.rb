class AddBusinessOutlineToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :business_outline, :string
  end
end
