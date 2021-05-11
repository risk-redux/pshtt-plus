class AddApprovedToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :approved, :boolean, :default => false, :null => false
    add_index  :users, :approved
  end
end
