class CreateAttendances < ActiveRecord::Migration[5.1]
  def change
    create_table :attendances do |t|
      t.references :user, foreign_key: true
      t.date :date
      t.time :start_time
      t.time :end_time
      t.integer :application_situation

      t.timestamps
    end
  end
end
