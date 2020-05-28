class EmailTemplate < ApplicationRecord
  has_many :campaigns

  validates :name, :subject, :message, presence: true
  validates :admin_id, numericality: { only_integer: true, greater_than: 0 }
  validates :archived, inclusion: { in: [ true, false ] }
  validate  :editable, on: :update

  def destroy
    return 'archived' if archived?

    if campaigns.length == 0
      super
      'destroyed'
    else
      update!({ archived: true })
      'archived'
    end
  end

  private

  def editable
    errors.add(:archived, 'is not editable') if archived_was == true
  end
end
