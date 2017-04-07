# frozen_string_literal: true
require 'rails_helper'

describe AssetType::Dataset do
  subject { described_class }

  describe "::all" do
    subject { described_class.all }
    it { is_expected.to contain_exactly("text/csv",
                                        "application/json",
                                        "application/x-filemaker",
                                        "application/vnd.ms-excel",
                                        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                                        "application/vnd.oasis.opendocument.spreadsheet",
                                        "application/xml",
                                        "application/twbx",
                                        "text/tab-separated-values",
                                        "application/vnd.google-earth.kml+xml") }
  end

  describe "::types" do
    subject { described_class.types }
    its(:first) { is_expected.to be_kind_of(MIME::Type::Columnar) }
  end
end
