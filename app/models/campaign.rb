require 'csv'

#
# TODO: Add statistics and store them in the database on .save!
#

class Campaign < ApplicationRecord
  include CsvRowToHash

  belongs_to :email_template
  attr_accessor :email_data

  validates :admin_id, :email_template_id, numericality: { only_integer: true, greater_than: 0 }
  validates :emails_queued, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates_with CsvFileValidator

  DEFAULT_TIME_BETWEEN_EMAILS = 6   # seconds
  DEFAULT_MAX_DAILY_EMAILS = 400

  def initialize(params = {})
    @time_between_emails = params.try(:[], :time_between_emails) || DEFAULT_TIME_BETWEEN_EMAILS
    @max_daily_emails = params.try(:[], :max_daily_emails) || DEFAULT_MAX_DAILY_EMAILS

    super(scrub_params(params))
  end

  def send_emails
    CSV.foreach(email_data.tempfile, headers: true).each do |row|
      row = csv_row_to_no_blanks_hash(row)
      next if skip_email?(row[:email])

      BulkMailer
          .with(user_id: admin_id, template: email_template, data: row)
          .send_mail
          .deliver_later(wait: email_delay)

      self.emails_queued += 1
    end
  end

  private

  def skip_email?(email)
    contact = Contact.find_or_create_by(email: email)
    return true unless contact.valid? # shouldn't happen, but we'll double check anyway

    contact.do_not_email?
  end

  def email_delay
    (day_offset + interday_offset).seconds
  end

  def day_offset
    # day * seconds_in_a_day
    emails_queued / @max_daily_emails.to_i * 86400
  end

  def interday_offset
    # number of email sent this day * time_between_emails
    (emails_queued % @max_daily_emails.to_i) * @time_between_emails
  end

  def scrub_params(params)
    return if params.nil?
    params.delete_if { |key, value| key.to_sym == :time_between_emails || key.to_sym == :max_daily_emails }
  end
end
