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
    @time_between_emails = params[:time_between_emails] || DEFAULT_TIME_BETWEEN_EMAILS
    @max_daily_emails = params[:max_daily_emails] || DEFAULT_MAX_DAILY_EMAILS

    super(scrub_params(params))
  end

  def send_emails
    CSV.foreach(email_data.tempfile, headers: true).each do |row|
      BulkMailer
          .with(template: email_template, data: csv_row_to_no_blanks_hash(row))
          .send_mail
          .deliver_later(wait: email_delay)

      self.emails_queued += 1
    end
  end

  private

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
    params.delete_if { |key, value| key.to_sym == :time_between_emails || key.to_sym == :max_daily_emails }
  end
end
