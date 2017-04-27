# frozen_string_literal: true
class DuplicateUploadVerificationService
  attr_reader :duplicates, :file

  # @param [Rack::Test::UploadedFile] file uploaded via Rack
  def initialize(file)
    @file = file
  end

  # @return [Array<GenericWork>]
  def duplicates
    duplicate_file_sets.map(&:parent)
  end

  # @return [Array<FileSet>]
  def duplicate_file_sets
    FileSet.where(digest_ssim: fedora_shasum)
  end

  private

    # Calculate the SHA1 checksum and format it like Fedora does
    def fedora_shasum
      "urn:sha1:#{Digest::SHA1.file(file_path)}"
    end

    def file_path
      return file.path if file.respond_to?(:path)
      file.file.file.path
    end
end
