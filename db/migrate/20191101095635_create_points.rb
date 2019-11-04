class CreatePoints < ActiveRecord::Migration[5.1]
  def change
    create_table :points do |t|
      t.integer :point_number
      t.string :point_name
      t.string :point_type

      t.timestamps
    end
  end
end
