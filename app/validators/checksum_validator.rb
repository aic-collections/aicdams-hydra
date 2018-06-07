# frozen_string_literal: true
class ChecksumValidator < ActiveModel::Validator
  include Rails.application.routes.url_helpers

  attr_reader :record

  def validate(record)
    @record = record
    if duplicates_in_solr?
      add_errors(:duplicate)
    elsif duplicates_in_process?
      add_errors(:begun_ingestion)
    elsif duplicates_in_batch?
      add_errors(:already_in_batch)
    end
  end

  private

    def add_errors(type_of_duplicate)
      record.errors.add(:checksum, build_message_hash(type_of_duplicate))
    end

    def duplicates_in_solr?
      duplicate_file_sets.present?
    end

    def duplicates_in_process?
      Sufia::UploadedFile.begun_ingestion.map(&:checksum).include?(record.checksum)
    end

    def duplicates_in_batch?
      Sufia::UploadedFile.where(uploaded_batch_id: record.uploaded_batch_id).map(&:checksum).include?(record.checksum)
    end

    def build_message_hash(type_of_duplicate)
      message_hash = {}

      message_hash[:error] = I18n.t("lakeshore.upload.errors.#{type_of_duplicate}", name: record.file.filename)

      if type_of_duplicate == :duplicate
        message_hash[:duplicate_path] = polymorphic_path(duplicate_file_sets.first.parent)
        message_hash[:duplicate_name] = duplicate_file_sets.first.parent.to_s
      end

      message_hash
    end

    # @return [Array<GenericWork>]
    def solr_duplicates?
      duplicate_file_sets.map(&:parent)
    end

    # @return [Array<FileSet>]
    def duplicate_file_sets
      @duplicate_file_sets ||= begin
                                 return [] if record.file.nil?
                                 FileSet.where(digest_ssim: record.checksum)
                               end
    end
end
