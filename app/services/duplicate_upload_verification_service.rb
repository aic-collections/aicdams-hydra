# frozen_string_literal: true
class DuplicateUploadVerificationService
  include Rails.application.routes.url_helpers

  attr_reader :duplicates, :file

  def self.unique?(file)
    new(file).duplicate_file_sets.empty?
  end

  # @return [Array<FileSet>]
  def duplicate_file_sets
    FileSet.where(digest_ssim: fedora_shasum)
  end

  # @param [Sufia::UploadedFile] file uploaded via Rack
  def initialize(file)
    unless file.is_a?(ActionDispatch::Http::UploadedFile)
      raise ArgumentError.new("must be an ActionDispatch::Http::UploadedFile")
    end
    @file = file
  end

  # @return [Array<GenericWork>]
  def duplicates
    duplicate_file_sets.map(&:parent)
  end

  private
    # returns array of one parent asset
    def parent_asset
      duplicate_file_sets.map(&:parent)
    end

    # Calculate the SHA1 checksum and format it like Fedora does
    def fedora_shasum
      "urn:sha1:#{Digest::SHA1.file(file_path)}"
    end

    def file_path
      return file.path if file.respond_to?(:path)
      file.file.file.path
    end
end
