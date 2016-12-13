# frozen_string_literal: true
require 'rails_helper'

describe AssetType::Sound do
  subject { described_class }

  describe "::all" do
    subject { described_class.all }
    it { is_expected.to contain_exactly("audio/aac",
                                        "audio/x-aiff",
                                        "audio/aiff",
                                        "audio/mpeg",
                                        "audio/m4a",
                                        "audio/wav",
                                        "audio/x-wav") }
  end

  describe "::types" do
    subject { described_class.types }
    its(:first) { is_expected.to be_kind_of(MIME::Type::Columnar) }
  end
end
