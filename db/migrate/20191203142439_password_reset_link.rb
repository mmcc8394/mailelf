class PasswordResetLink < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :password_reset_guid, :string
  end
end
