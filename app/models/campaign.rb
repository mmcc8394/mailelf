class Campaign < ApplicationRecord
  belongs_to :email_template
  attr_accessor :email_data

  validates :admin_id, :email_template_id, numericality: { only_integer: true, greater_than: 0 }
  validates :email_data, presence: true
end
