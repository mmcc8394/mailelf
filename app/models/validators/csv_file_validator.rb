class CsvFileValidator < ActiveModel::Validator
  include CsvRowToHash

  def validate(record)
    if record.email_data.blank?
      record.errors[:email_data] << "can't be blank"
    elsif record.email_template
      begin
        CSV.foreach(record.email_data.tempfile, headers: true).each do |row|
          record.email_template.message % csv_row_to_no_blanks_hash(row)
        end
      rescue KeyError
        record.errors[:email_data] << 'CSV file missing key(s)'
      end
    end
  end
end