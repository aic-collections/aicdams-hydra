# frozen_string_literal: false
require 'rails_helper'

describe Sufia::UploadedFile do
  context "when the object is new" do
    describe "#status" do
      it "gets set to 'new'" do
        expect(subject.new_record?).to be_truthy
        expect(subject.status).to eq("new")
      end
    end
  end

  context "when the object is being saved" do
    describe "#checksum" do
      let(:uploaded_file) { build(:uploaded_file) }
      it "gets calculated automatically before_validation" do
        expect(uploaded_file.new_record?).to be_truthy
        expect(uploaded_file.checksum).to be_nil
        expect(uploaded_file).to receive(:calculate_checksum)
        uploaded_file.valid?
      end

      before { create(:uploaded_file_that_began_ingestion) }
      it "is invalid if the checksum already exists on a file that has begun_ingestion" do
        uploaded_file.valid?
        error = { error: "sun.png has already begun ingestion." }
        expect(uploaded_file.errors[:checksum]).to include(error)
      end
    end
  end
end
