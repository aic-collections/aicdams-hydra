# frozen_string_literal: true
module AssetType
  class Text < Base
    def self.all
      [
        "application/msword", "application/pdf", "application/rtf", "application/vnd.ms-powerpoint",
        "application/vnd.oasis.opendocument.text",
        "application/vnd.openxmlformats-officedocument.presentationml.presentation",
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
        "image/jpeg", "image/png", "image/tiff", "text/html", "text/markdown", "text/plain"
      ]
    end
  end
end
