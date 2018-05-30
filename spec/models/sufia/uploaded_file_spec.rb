# frozen_string_literal: false
require 'rails_helper'

describe Sufia::UploadedFile do
  # bang this so it is not memoized and gets invoked even after tmp dir is wiped via LakeshoreTesting
  # https://cits.artic.edu/issues/2943
  let!(:file) do
    ActionDispatch::Http::UploadedFile.new(filename:     "sun.png",
                                           content_type: "image/png",
                                           tempfile:     File.new(File.join(fixture_path, "sun.png")))
  end
  let(:user) { create(:user1) }
  let(:use) { "http://file.use.uri" }

  subject { described_class.new(file: file, user: user, use_uri: use) }

  before { LakeshoreTesting.restore }

  describe "#use_uri" do
    its(:use_uri) { is_expected.to eq(use) }
  end

  describe "duplicate checking in same batch" do
    context "when no other duplicate exists" do
      it "checksum is valid" do
        expect(described_class.where(checksum: subject.checksum)).to be_empty
        expect(subject).to be_valid
      end
    end

    context "when a duplicate exists" do
      before { described_class.create(file: file, user: user, use_uri: use) }

      it "checksum is not valid" do
        expect(subject).not_to be_valid
      end
    end
  end

  context "when the file has already begun ingestion" do
    before { described_class.create(file: file, user: user, use_uri: use, status: "begun_ingestion") }

    it "the checksum is invalid" do
      expect(subject).not_to be_valid
      expect(subject.errors.messages[:checksum]).to eq([error: "sun.png has already begun ingestion."])
    end
  end
end
