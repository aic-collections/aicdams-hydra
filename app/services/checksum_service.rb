# frozen_string_literal: true
module ChecksumService
  # Calculate the SHA1 checksum and format it like Fedora does
  def fedora_shasum
    "urn:sha1:#{Digest::SHA1.file(file_path)}"
  end

  def file_path
    return file.path if file.respond_to?(:path)
    file.file.file.path
  end
end
