class RemoveDecisionFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :decision, :integer
  end
end
