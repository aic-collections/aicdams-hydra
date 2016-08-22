# frozen_string_literal: true
class AssetTypeVerificationService
  STILL_IMAGE_TYPES = [
    "application/pdf",
    "image/jpeg",
    "image/png",
    "image/tiff",
    "image/vnd.adobe.photoshop"
  ].freeze

  TEXT_TYPES = [
    "application/msword",
    "application/pdf",
    "application/rtf",
    "application/vnd.ms-powerpoint",
    "application/vnd.oasis.opendocument.text",
    "application/vnd.openxmlformats-officedocument.presentationml.presentation",
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
    "image/jpeg",
    "image/png",
    "image/tiff",
    "text/html",
    "text/markdown",
    "text/plain"
  ].freeze

  class << self
    # @param [Rack::Test::UploadedFile] file uploaded via Rack
    # @param [AICType, String] asset_type
    # @return [Boolean]
    def call(file, asset_type)
      return verify_still_image(file.original_filename) if asset_type == AICType.StillImage
      return verify_text(file.original_filename) if asset_type == AICType.Text
      false
    end

    def verify_still_image(file)
      !(STILL_IMAGE_TYPES & MIME::Types.of(file).map(&:content_type)).empty?
    end

    def verify_text(file)
      !(TEXT_TYPES & MIME::Types.of(file).map(&:content_type)).empty?
    end
  end
end
