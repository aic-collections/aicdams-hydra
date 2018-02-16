# frozen_string_literal: false
require 'rails_helper'

describe Sufia::UploadedFile do
  let(:file) do
    ActionDispatch::Http::UploadedFile.new(filename:     "sun.png",
                                           content_type: "image/png",
                                           tempfile:     File.new(File.join(fixture_path, "sun.png")))
  end
  let(:user) { create(:user1) }

  let(:use) { "http://file.use.uri" }
  subject { described_class.new(file: file, user: user) }

  describe "#status" do
    it "gets set to 'new'" do
      expect(subject.status).to eq("new")
    end
  end

  describe "#checksum" do

    before do
      subject.checksum = ""
    end

    it "is invalid with no checksum" do
      allow(subject).to receive(:fedora_shasum) { "" }
      subject.valid?
      expect(subject.errors[:checksum]).to include("can't be blank")
    end

    before { subject.checksum = "checksum" }

    it "gets calculated automatically before_save" do
      expect(subject).to receive(:calculate_checksum).with(no_args)
      subject.save
    end

    before { subject.checksum = 'checksum' }
    it "is valid with a checksum" do
      subject.valid?
      expect(subject.errors[:checksum]).not_to include("can't be blank")
    end

    before { described_class.create(file: file, user: user, status: "begun_ingestion") }

    it "is invalid if the checksum already exists on a file that has begun_ingestion" do
      subject.valid?
      expect(subject.errors[:checksum]).to include("File has already begun ingestion.")
    end
  end
end
