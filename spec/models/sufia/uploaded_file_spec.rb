# frozen_string_literal: false
require 'rails_helper'

describe Sufia::UploadedFile do
  context "when the object is new" do
    subject { described_class.new }
    describe "#status" do
      it "gets set to 'new'" do
        expect(subject.status).to eq("new")
      end
    end
  end

  context "when the object is being saved" do
    subject { create(:uploaded_file) }

    describe "#checksum" do
      # before { subject.checksum = "checksum" }

      it "gets calculated automatically before_save" do
        subject.checksum = "checksum"
        expect(subject).to receive(:calculate_checksum).with(no_args)
        subject.save
      end

      # before { subject.checksum = 'checksum' }
      it "is valid with a checksum" do
        subject.checksum = 'checksum'
        subject.valid?
        expect(subject.errors[:checksum]).not_to include("can't be blank")
      end

      # before { described_class.create(file: file, user: user, status: "begun_ingestion") }

      it "is invalid if the checksum already exists on a file that has begun_ingestion" do
        subject.valid?
        expect(subject.errors[:checksum]).to include("File has already begun ingestion.")
      end
    end
  end
end
