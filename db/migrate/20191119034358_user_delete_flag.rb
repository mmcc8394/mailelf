class UserDeleteFlag < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :deleted, :boolean, default: false, null: false
  end
end
