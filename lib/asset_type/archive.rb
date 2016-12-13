# frozen_string_literal: true
module AssetType
  class Archive < Base
    def self.all
      [
        "application/x-7z-compressed", "application/x-bzip2", "application/x-tar",
        "application/x-gtar", "application/x-xz", "application/zip"
      ]
    end
  end
end
