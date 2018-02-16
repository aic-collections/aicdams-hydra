# frozen_string_literal: true
module UploadedFile
  include Lakeshore::ChecksumService
  extend ActiveSupport::Concern

  included do
    extend ClassMethods
    after_initialize :set_status, if: "status.nil?"
    before_validation :calculate_checksum
    validates :checksum, presence: true, checksum: true

    scope :begun_ingestion, -> { where(status: "begun_ingestion") }
  end

  private

    def calculate_checksum
      self.checksum = fedora_shasum
    end

    def set_status
      self.status = "new"
    end

  module ClassMethods
    def flip_status(uploaded_files_ids)
      uploaded_files_ids.each do |uploaded_file_id|
        find(uploaded_file_id).update_attribute(:status, "begun_ingestion")
      end
    end
  end
end
