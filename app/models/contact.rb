class Contact < ApplicationRecord
  validates :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'invalid email format' }
  validates :do_not_email, inclusion: { in: [ true, false ], message: 'must be a boolean value' }

  def set_do_not_email
    update({ do_not_email: true })
  end
end
