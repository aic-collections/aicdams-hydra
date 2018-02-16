# frozen_string_literal: true
class DuplicateUploadVerificationService
  include Lakeshore::ChecksumService
  attr_reader :duplicates, :file

  def self.unique?(file)
    new(file).duplicate_file_sets.empty?
  end

  # @param [Sufia::UploadedFile] file uploaded via Rack
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
end
