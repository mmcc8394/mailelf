module CsvRowToHash
  # quirk of serialization: turns symbols to strings - turn them back to symbols
  def csv_row_to_hash(row)
    row.to_hash.transform_keys(&:to_sym)
  end

  def csv_row_to_no_blanks_hash(row)
    csv_row_to_hash(row).delete_if { |key, value| value.blank? }
  end
end