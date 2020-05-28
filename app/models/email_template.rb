class EmailTemplate < ApplicationRecord
  has_many :campaigns

  validates :name, :subject, :message, presence: true
  validates :admin_id, numericality: { only_integer: true, greater_than: 0 }
  validates :archived, inclusion: { in: [ true, false ] }

  def destroy
    if campaigns.length == 0
      super
      'destroyed'
    else
      update!({ archived: true })
      'archived'
    end
  end
end
