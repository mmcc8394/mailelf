class Campaign < ApplicationRecord
  belongs_to :email_template

  validates :admin_id, :email_template_id, numericality: { only_integer: true, greater_than: 0 }
end
