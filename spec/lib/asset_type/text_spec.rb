# frozen_string_literal: true
require 'rails_helper'

describe AssetType::Text do
  subject { described_class }

  describe "::all" do
    subject { described_class.all }
    it { is_expected.to contain_exactly("application/msword",
                                        "application/pdf",
                                        "application/rtf",
                                        "application/vnd.ms-powerpoint",
                                        "application/vnd.oasis.opendocument.text",
                                        "application/vnd.openxmlformats-officedocument.presentationml.presentation",
                                        "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
                                        "image/jpeg",
                                        "image/png",
                                        "image/tiff",
                                        "text/html",
                                        "text/markdown",
                                        "text/plain")}
  end

  describe "::types" do
    subject { described_class.types }
    its(:first) { is_expected.to be_kind_of(MIME::Type::Columnar) }
  end
end
