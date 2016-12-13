# frozen_string_literal: true
require 'rails_helper'

describe AssetType::StillImage do
  subject { described_class }

  describe "::all" do
    subject { described_class.all }
    it { is_expected.to contain_exactly("application/pdf",
                                        "image/jpeg",
                                        "image/png",
                                        "image/tiff",
                                        "image/vnd.adobe.photoshop")}
  end

  describe "::types" do
    subject { described_class.types }
    its(:first) { is_expected.to be_kind_of(MIME::Type) }
  end
end
