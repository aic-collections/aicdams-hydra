# frozen_string_literal: true
require 'rails_helper'

describe AssetType::Archive do
  subject { described_class }

  describe "::all" do
    subject { described_class.all }
    it { is_expected.to contain_exactly("application/x-7z-compressed",
                                        "application/x-bzip2",
                                        "application/x-tar",
                                        "application/x-gtar",
                                        "application/x-xz",
                                        "application/zip") }
  end

  describe "::types" do
    subject { described_class.types }
    its(:first) { is_expected.to be_kind_of(MIME::Type::Columnar) }
  end
end
