class CsvFileValidator < ActiveModel::Validator
  include CsvRowToHash

  def validate(record)
    if record.email_data.blank?
      record.errors[:email_data] << "can't be blank"
    elsif record.email_template
      CSV.foreach(record.email_data.tempfile, headers: true).each do |row|
        return unless has_email_field(record, row)
        return unless valid_email(record, row)
        return unless has_keys_and_values(record, row)
      end
    end
  end

  private

  def has_email_field(record, row)
    unless row.key?('email')
      record.errors[:email_data] << 'email field required in CSV file'
      return false
    end

    true
  end

  def valid_email(record, row)
    unless row['email'] =~ URI::MailTo::EMAIL_REGEXP
      record.errors[:email_data] << 'invalid email(s) in CSV file'
      return false
    end

    true
  end

  def has_keys_and_values(record, row)
    begin
      record.email_template.message % csv_row_to_no_blanks_hash(row)
      return true
    rescue KeyError
      record.errors[:email_data] << 'CSV file missing key(s)'
      return false
    end
  end
end