class CreateCampaigns < ActiveRecord::Migration[6.0]
  def change
    create_table :campaigns do |t|
      t.integer :admin_id, null: false
      t.integer :email_template_id, null: false
      t.integer :emails_queued, null: false, default: 0

      t.timestamps
    end
  end
end
