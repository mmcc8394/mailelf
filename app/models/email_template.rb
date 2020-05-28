class EmailTemplate < ApplicationRecord
  validates :name, :subject, :message, presence: true
  validates :admin_id, numericality: { only_integer: true, greater_than: 0 }
end
