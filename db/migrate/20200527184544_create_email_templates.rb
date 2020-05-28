class CreateEmailTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :email_templates do |t|
      t.string :name, null: false
      t.string :subject, null: false
      t.text :message, null: false
      t.integer :admin_id, null: false
      t.boolean :archived, default: false, null: false

      t.timestamps
    end
  end
end
