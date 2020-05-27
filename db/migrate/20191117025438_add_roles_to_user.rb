class AddRolesToUser < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :role
    add_column :users, :roles, :string, array: true, default: []
  end
end
