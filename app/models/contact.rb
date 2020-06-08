require 'securerandom'

class Contact < ApplicationRecord
  before_validation :generate_guid, on: :create

  validates :email, :guid, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'invalid email format' }
  validates :do_not_email, inclusion: { in: [ true, false ], message: 'must be a boolean value' }
  validates :guid, format: { with: /[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-\b[0-9a-fA-F]{12}/, message: 'invalid guid format' }

  def set_do_not_email
    update({ do_not_email: true })
  end

  private

  def generate_guid
    self.guid = SecureRandom.uuid
  end
end
