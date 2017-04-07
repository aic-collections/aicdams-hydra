# frozen_string_literal: true
require 'rails_helper'

describe AssetType::MovingImage do
  subject { described_class }

  describe "::all" do
    subject { described_class.all }
    it { is_expected.to contain_exactly("video/3gpp",
                                        "video/3gpp2",
                                        "image/gif",
                                        "video/mp4",
                                        "video/quicktime",
                                        "video/webm",
                                        "video/x-flv",
                                        "video/x-msvideo",
                                        "video/x-ms-wmv",
                                        "video/mts",
                                        "application/x-director",
                                        "application/x-shockwave-flash") }
  end

  describe "::types" do
    subject { described_class.types }
    its(:first) { is_expected.to be_kind_of(MIME::Type::Columnar) }
  end
end
