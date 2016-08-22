# frozen_string_literal: true
require 'rails_helper'

describe BatchAssetCreateJob do
  let(:user) { create(:user1) }
  let(:log)  { create(:batch_create_operation, user: user) }

  before do
    allow(CharacterizeJob).to receive(:perform_later)
    allow(CurationConcerns.config.callback).to receive(:run)
    allow(CurationConcerns.config.callback).to receive(:set?).with(:after_batch_create_success).and_return(true)
    allow(CurationConcerns.config.callback).to receive(:set?).with(:after_batch_create_failure).and_return(true)
  end

  describe "#perform" do
    let(:file1)          { File.open(fixture_path + '/sun.png') }
    let(:file2)          { File.open(fixture_path + '/tardis.png') }
    let(:upload1)        { Sufia::UploadedFile.create(user: user, file: file1) }
    let(:upload2)        { Sufia::UploadedFile.create(user: user, file: file2) }
    let(:pref_labels)    { { upload1.id.to_s => 'File One', upload2.id.to_s => 'File Two' } }
    let(:metadata)       { { asset_type: AICType.StillImage.to_s } }
    let(:uploaded_files) { [upload1.id.to_s, upload2.id.to_s] }
    let(:asset)          { double }
    let(:actor)          { double(curation_concern: asset) }

    subject do
      described_class.perform_later(user, pref_labels, uploaded_files, metadata, log)
    end

    it "updates asset metadata" do
      expect(CurationConcerns::CurationConcern).to receive(:actor).and_return(actor).twice
      expect(actor).to receive(:create).with(asset_type: AICType.StillImage.to_s, pref_label: 'File One', uploaded_files: ['1']).and_return(true)
      expect(actor).to receive(:create).with(asset_type: AICType.StillImage.to_s, pref_label: 'File Two', uploaded_files: ['2']).and_return(true)
      expect(CurationConcerns.config.callback).to receive(:run).with(:after_batch_create_success, user)
      subject
      expect(log.status).to eq 'pending'
      expect(log.reload.status).to eq 'success'
    end
  end
end
