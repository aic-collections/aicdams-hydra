class ChecksumValidator < ActiveModel::Validator
  def validate(record)
    if Sufia::UploadedFile.begun_ingestion.map { |file| file.checksum }.include?(record.checksum)
      record.errors.add(:checksum, "File has already begun ingestion.")
    end
  end
end