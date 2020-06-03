require 'csv'

class Campaign < ApplicationRecord
  belongs_to :email_template
  attr_accessor :email_data

  validates :admin_id, :email_template_id, numericality: { only_integer: true, greater_than: 0 }
  validates :email_data, presence: true

  def send_emails
    CSV.foreach(email_data.tempfile, headers: true).each do |line|
      BulkMailer.with(template: email_template, data: line.to_hash).send_mail.deliver_later
    end
  end
end
