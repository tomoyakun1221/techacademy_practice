class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :uid
      t.string :name
      t.integer :role, defalut: 0
      t.integer :superior_flag
      t.integer :admin_flag
      t.integer :admin
      t.string :password_digest

      t.timestamps
    end
  end
end
