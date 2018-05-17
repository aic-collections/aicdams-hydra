# frozen_string_literal: true
class ChecksumValidator < ActiveModel::Validator
  include Rails.application.routes.url_helpers

  attr_reader :record

  def validate(record)
    @record = record
    if !verification_service.duplicates.empty?
      record.errors.add(:checksum, in_solr_error_message)
    elsif Sufia::UploadedFile.begun_ingestion.map(&:checksum).include?(record.checksum)
      record.errors.add(:checksum, begun_ingestion_error_message)
    elsif Sufia::UploadedFile.where(uploaded_batch_id: record.uploaded_batch_id).map(&:checksum).include?(record.checksum)
      record.errors.add(:checksum, already_in_batch_error_message)
    end
  end

  private

    def in_solr_error_message
      {
        error:          I18n.t('lakeshore.upload.errors.duplicate', name: @record.file.filename),
        duplicate_path: polymorphic_path(verification_service.duplicates.first),
        duplicate_name: verification_service.duplicates.first.to_s
      }
    end

    def begun_ingestion_error_message
      {
        error:          I18n.t('lakeshore.upload.errors.begun_ingestion', name: @record.file.filename)
      }
    end

    def already_in_batch_error_message
      {
        error:          I18n.t('lakeshore.upload.errors.already_in_batch', name: @record.file.filename)
      }
    end

    def verification_service
      @verification_service ||= DuplicateUploadVerificationService.new(record.file)
    end
end
