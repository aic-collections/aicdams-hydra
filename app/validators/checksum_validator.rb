# frozen_string_literal: true
class ChecksumValidator < ActiveModel::Validator
  include Rails.application.routes.url_helpers
  def validate(record)
    @record = record
    @uploaded_file = @record.file
    @duvs_obj = DuplicateUploadVerificationService.new(@uploaded_file)
    if !@duvs_obj.duplicates.empty?
      record.errors.add(:checksum, in_solr_error_message)
    elsif Sufia::UploadedFile.begun_ingestion.map(&:checksum).include?(@record.checksum)
      record.errors.add(:checksum, begun_ingestion_error_message)
    end
  end

  private

    def in_solr_error_message
      byebug
      {
        error:          I18n.t('lakeshore.upload.errors.duplicate', name: @record.file.filename),
        duplicate_path: polymorphic_path(@duvs_obj.duplicates.first),
        duplicate_name: @duvs_obj.duplicates.first.to_s
      }
    end

    def begun_ingestion_error_message
      {
        error:          I18n.t('lakeshore.upload.errors.begun_ingestion', name: @record.file.filename)
      }
    end
end
