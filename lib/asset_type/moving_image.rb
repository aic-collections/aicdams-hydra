# frozen_string_literal: true
module AssetType
  class MovingImage < Base
    def self.all
      [
        "video/3gpp", "video/3gpp2", "image/gif", "video/mp4", "video/quicktime",
        "video/webm", "video/x-flv", "video/x-msvideo", "video/x-ms-wmv", "video/mts",
        "application/x-director", "application/x-shockwave-flash"
      ]
    end
  end
end
