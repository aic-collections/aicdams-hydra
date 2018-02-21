# frozen_string_literal: true
class ChecksumValidator < ActiveModel::Validator
  include Rails.application.routes.url_helpers
  def validate(record)
    @record = record
    if !DuplicateUploadVerificationService.new(record).duplicates.empty?
      record.errors.add(:checksum, in_solr_error_message)
    elsif Sufia::UploadedFile.begun_ingestion.map(&:checksum).include?(record.checksum)
      record.errors.add(:checksum, begun_ingestion_error_message)
    end
  end

  private

    def in_solr_error_message
      {
        error:          I18n.t('lakeshore.upload.errors.duplicate', name: @record.uploaded_file.original_filename),
        duplicate_path: polymorphic_path(DuplicateUploadVerificationService.new(@record.uploaded_file).duplicates.first),
        duplicate_name: DuplicateUploadVerificationService.new(@record.uploaded_file).duplicates.first.to_s
      }
    end

    def begun_ingestion_error_message
      {
        error:          "File has already begun ingestion."
      }
    end
end
