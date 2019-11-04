class AddBasicInfoToUsers < ActiveRecord::Migration[5.1]
  def change
<<<<<<< HEAD
    add_column :users, :basic_time, :datetime, default: Time.current.change(hour: 8, min: 0, sec: 0)
=======
    add_column :users, :basic_time, :datetime, default: Time.current.change(hour: 8,min: 0, sec: 0)
>>>>>>> 2bd5adf2fe1132420affc68ac87363a2b8f9e962
    add_column :users, :work_time, :datetime, default: Time.current.change(hour: 7, min: 30, sec: 0)
  end
end
