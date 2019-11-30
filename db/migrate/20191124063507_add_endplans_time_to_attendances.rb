class AddEndplansTimeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :endplans_time, :datetime
  end
end
