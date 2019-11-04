class AddDecisionToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :decision, :integer
  end
end
