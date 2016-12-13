# frozen_string_literal: true
module AssetType
  class Sound < Base
    def self.all
      ["audio/aac", "audio/aiff", "audio/x-aiff", "audio/mpeg", "audio/m4a", "audio/wav", "audio/x-wav"]
    end
  end
end
