# frozen_string_literal: true
module Lakeshore
  class IngestFile
    attr_reader :file, :type, :user

    delegate :original_filename, to: :file
    delegate :errors, to: :uploaded_file

    def self.uri_map
      {
        original: AICType.OriginalFileSet,
        intermediate: AICType.IntermediateFileSet,
        pres_master: AICType.PreservationMasterFileSet,
        legacy: AICType.LegacyFileSet
      }
    end

    def self.types
      uri_map.keys
    end

    # @param [User] user depositor performing the ingest from the API
    # @param [ActionDispatch::Http::UploadedFile] file uploaded from the API
    # @param [Symbol] type for the FileSet that has a registered URI
    def initialize(user:, file:, type:)
      @type = type
      @file = file
      @user = user
    end

    def uri
      @uri ||= register_uri
    end

    def duplicate?
      errors.key?(:checksum)
    end

    def unique?
      !duplicate?
    end

    def uploaded_file
      @uploaded_file ||= create_file(file, user)
    end

    # @return [String] id of uploaded file for API
    def uploaded_file_id
      return if uploaded_file.nil?
      uploaded_file.id.to_s
    end

    private

      def register_uri
        return if type.nil?
        self.class.uri_map[type] || raise(UnsupportedFileSetTypeError, "'#{type}' is not a supported file set type")
      end

      def create_file(file, user)
        return if file.nil?
        Sufia::UploadedFile.create(file: file, user: user, use_uri: uri)
      end

      class UnsupportedFileSetTypeError < StandardError; end
  end
end
