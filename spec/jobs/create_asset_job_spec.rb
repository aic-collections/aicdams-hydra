# frozen_string_literal: true
require 'rails_helper'

describe CreateAssetJob do
  let(:user)       { create(:user1) }
  let(:file)       { create(:uploaded_file) }
  let(:attributes) { { uploaded_files: [file.id] } }
  let(:log)        { Sufia::BatchCreateOperation.new }
  let(:actor)      { double }
  let(:service)    { double }

  before do
    allow(CurationConcerns::CurationConcern).to receive(:actor)
      .with(instance_of(GenericWork), user)
      .and_return(actor)
  end

  context "with a new file" do
    before { allow(actor).to receive(:create).and_return(true) }

    it "performs the job successfully" do
      expect(DuplicateUploadVerificationService).to receive(:unique?).with(file).and_return(true)
      described_class.perform_now(user, "GenericWork", attributes, log)
      expect(log.status).to eq("success")
    end
  end

  context "with a duplicate file" do
    it "halts the job and raises an error" do
      expect(actor).not_to receive(:create)
      expect(DuplicateUploadVerificationService).to receive(:unique?).with(file).and_return(false)
      expect {
        described_class.perform_now(user, "GenericWork", attributes, log)
      }.to raise_error(Lakeshore::DuplicateAssetError)
    end
  end
end
