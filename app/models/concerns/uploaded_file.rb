# frozen_string_literal: true
module UploadedFile
  include Lakeshore::ChecksumService
  extend ActiveSupport::Concern

  included do
    extend ClassMethods
    after_initialize :set_status, if: "status.nil?"
    before_validation :calculate_checksum
    validates :checksum, presence: true, checksum: true, on: :create

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
    # @param [Array] uploaded_files_ids array of ids in batch upload
    # @param [String] new string that status should be updated to
    def change_status(uploaded_files_ids, str)
      where(id: uploaded_files_ids).update_all(status: str)
    end
  end
end
