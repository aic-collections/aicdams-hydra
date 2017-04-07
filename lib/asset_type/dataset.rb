# frozen_string_literal: true
module AssetType
  class Dataset < Base
    def self.all
      [
        "text/csv", "application/json", "application/x-filemaker", "application/vnd.ms-excel",
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        "application/vnd.oasis.opendocument.spreadsheet", "application/xml",
        "text/tab-separated-values", "application/twbx", "application/vnd.google-earth.kml+xml"
      ]
    end
  end
end
