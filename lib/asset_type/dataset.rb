# frozen_string_literal: true
module AssetType
  class Dataset < Base
    def self.all
      [
        "text/csv", "application/json", "application/x-filemaker", "application/x-msexcel",
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        "application/vnd.oasis.opendocument.spreadsheet", "application/xml",
        "text/tab-separated-values"
      ]
    end
  end
end
