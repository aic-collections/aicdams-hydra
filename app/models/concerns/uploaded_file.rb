# frozen_string_literal: true
module UploadedFile
  include ChecksumService
  extend ActiveSupport::Concern

  included do
    extend ClassMethods
    belongs_to :batch_upload
    after_initialize :set_status, if: "status.nil?"
    before_validation :calculate_checksum

    validates :checksum, presence: true, checksum: true, on: :create

    scope :begun_ingestion, -> { where(status: "begun_ingestion") }

    attr_accessor :uploaded_file
  end

  module ClassMethods
    # @param [Array] uploaded_files_ids array of ids in batch upload
    # @param [String] new string that status should be updated to
    def change_status(uploaded_files_ids, str)
      where(id: uploaded_files_ids).update_all(status: str)
    end
  end

  private

    def calculate_checksum
      self.checksum = fedora_shasum
    end

    def set_status
      self.status = "new"
    end
end
