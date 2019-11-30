class AddOverNextDayToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :over_next_day, :boolean
  end
end
