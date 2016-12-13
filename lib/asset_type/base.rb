# frozen_string_literal: true
module AssetType
  class Base
    def self.key
      to_s.split("::").last.downcase
    end

    def self.all
      []
    end

    def self.types
      all.map { |t| MIME::Types[t] }.flatten
    end
  end
end
