# frozen_string_literal: true
require 'rails_helper'

describe CreateAssetJob do
  let(:file)          { File.open(File.join(fixture_path, "sun.png")) }
  let(:user)          { create(:user1) }
  let(:uploaded_file) { Sufia::UploadedFile.create(file: file, user: user, use_uri: AICType.OriginalFileSet) }
  let(:attributes)    { { uploaded_files: [uploaded_file.id] } }
  let(:log)           { Sufia::BatchCreateOperation.new }
  let(:actor)         { double }
  let(:service)       { double }

  before do
    LakeshoreTesting.restore
    allow(CurationConcerns::CurationConcern).to receive(:actor)
      .with(instance_of(GenericWork), user)
      .and_return(actor)
  end

  context "with a new file" do
    before { allow(actor).to receive(:create).and_return(true) }

    it "performs the job successfully" do
      expect(DuplicateUploadVerificationService).to receive(:unique?).with(uploaded_file).and_return(true)
      described_class.perform_now(user, "GenericWork", attributes, log)
      expect(log.status).to eq("success")
    end
  end

  context "with a duplicate file" do
    it "halts the job and raises an error" do
      expect(actor).not_to receive(:create)
      expect(DuplicateUploadVerificationService).to receive(:unique?).with(uploaded_file).and_return(false)
      expect {
        described_class.perform_now(user, "GenericWork", attributes, log)
      }.to raise_error(Lakeshore::DuplicateAssetError)
    end
  end
end
