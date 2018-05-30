# frozen_string_literal: true
require 'rails_helper'

describe BatchAssetCreateJob do
  let(:user) { create(:user1) }
  let(:log)  { create(:batch_create_operation, user: user) }

  before do
    allow(CharacterizeJob).to receive(:perform_later)
    allow(DuplicateUploadVerificationService).to receive(:unique?).and_return(true)
    allow(CurationConcerns.config.callback).to receive(:run)
    allow(CurationConcerns.config.callback).to receive(:set?).with(:after_batch_create_success).and_return(true)
    allow(CurationConcerns.config.callback).to receive(:set?).with(:after_batch_create_failure).and_return(true)
  end

  describe "#perform" do
    subject do
      described_class.perform_later(user, params, metadata, log)
    end

    context "with uploaded files" do
      let(:file1)    { File.open(fixture_path + '/sun.png') }
      let(:file2)    { File.open(fixture_path + '/tardis.png') }
      let(:upload1)  { Sufia::UploadedFile.create(user: user, file: file1) }
      let(:upload2)  { Sufia::UploadedFile.create(user: user, file: file2) }
      let(:metadata) { { asset_type: AICType.StillImage.to_s } }
      let(:asset)    { double }
      let(:actor)    { double(curation_concern: asset) }

      let(:params) do
        ActionController::Parameters.new(
          pref_label: { upload1.id.to_s => 'File One', upload2.id.to_s => 'File Two' },
          uploaded_files: [upload1.id.to_s, upload2.id.to_s]
        )
      end

      before { LakeshoreTesting.restore }

      it "creates two assets" do
        expect(CurationConcerns::CurationConcern).to receive(:actor).and_return(actor).twice
        expect(actor).to receive(:create).with(asset_type: AICType.StillImage.to_s, pref_label: 'File One', uploaded_files: ['1']).and_return(true)
        expect(actor).to receive(:create).with(asset_type: AICType.StillImage.to_s, pref_label: 'File Two', uploaded_files: ['2']).and_return(true)
        expect(CurationConcerns.config.callback).to receive(:run).with(:after_batch_create_success, user)
        subject
        expect(log.status).to eq 'pending'
        expect(log.reload.status).to eq 'success'
      end
    end

    context "with an external file and label" do
      let(:metadata) do
        {
          asset_type: AICType.StillImage.to_s,
          external_file: "some-url",
          external_file_label: "some-url-label"
        }
      end

      let(:asset)    { double }
      let(:actor)    { double(curation_concern: asset) }
      let(:params)   { {} }

      it "creates an asset with a url" do
        expect(CurationConcerns::CurationConcern).to receive(:actor).and_return(actor)
        expect(actor).to receive(:create).with(asset_type: AICType.StillImage.to_s,
                                               external_resources: ['some-url'],
                                               pref_label: 'some-url-label')
          .and_return(true)
        expect(CurationConcerns.config.callback).to receive(:run).with(:after_batch_create_success, user)
        subject
        expect(log.status).to eq 'pending'
        expect(log.reload.status).to eq 'success'
      end
    end

    context "with an external file and no label" do
      let(:metadata) do
        {
          asset_type: AICType.StillImage.to_s,
          external_file: "some-url"
        }
      end

      let(:asset)    { double }
      let(:actor)    { double(curation_concern: asset) }
      let(:params)   { {} }

      it "creates an asset with a url" do
        expect(CurationConcerns::CurationConcern).to receive(:actor).and_return(actor)
        expect(actor).to receive(:create).with(asset_type: AICType.StillImage.to_s,
                                               external_resources: ['some-url'],
                                               pref_label: 'some-url')
          .and_return(true)
        expect(CurationConcerns.config.callback).to receive(:run).with(:after_batch_create_success, user)
        subject
        expect(log.status).to eq 'pending'
        expect(log.reload.status).to eq 'success'
      end
    end
  end
end
