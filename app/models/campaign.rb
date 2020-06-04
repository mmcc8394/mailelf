require 'csv'

#
# TODO: Add statistics and store them in the database on .save!
#

class Campaign < ApplicationRecord
  include CsvRowToHash

  belongs_to :email_template
  attr_accessor :email_data

  validates :admin_id, :email_template_id, numericality: { only_integer: true, greater_than: 0 }
  validates_with CsvFileValidator

  def send_emails
    CSV.foreach(email_data.tempfile, headers: true).each do |row|
      BulkMailer.with(template: email_template, data: csv_row_to_no_blanks_hash(row)).send_mail.deliver_later
    end
  end
end
