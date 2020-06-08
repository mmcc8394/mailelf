class CreateContacts < ActiveRecord::Migration[6.0]
  def change
    create_table :contacts do |t|
      t.string :email, null: false
      t.boolean :do_not_email, default: false, null: false

      t.timestamps
    end
  end
end
