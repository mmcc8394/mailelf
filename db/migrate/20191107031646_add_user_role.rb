class AddUserRole < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :role, :string, null: false, default: 'basic'
  end
end
