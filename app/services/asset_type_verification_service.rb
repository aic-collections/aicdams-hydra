# frozen_string_literal: true
class AssetTypeVerificationService
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
      !(AssetType::Image.all & MIME::Types.of(file).map(&:content_type)).empty?
    end

    def verify_text(file)
      !(AssetType::Text.all & MIME::Types.of(file).map(&:content_type)).empty?
    end
  end
end
