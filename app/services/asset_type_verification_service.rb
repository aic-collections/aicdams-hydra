# frozen_string_literal: true
class AssetTypeVerificationService
  class << self
    # @param [Rack::Test::UploadedFile] file uploaded via Rack
    # @param [AICType, String] asset_type
    # @return [Boolean]
    def call(file, asset_type)
      type_class = "AssetType::#{asset_type.to_s.split('/').last}".constantize
      !(type_class.all & MIME::Types.of(file.original_filename).map(&:content_type)).empty?
    end
  end
end
