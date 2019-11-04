class AddUserDesignatedWorkEndTimeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :user_designated_work_end_time, :datetime, default: Time.current.change(hour: 18, min: 0, sec: 0)
  end
end
