# frozen_string_literal: false
require 'rails_helper'

describe Lakeshore::IngestController do
  let(:apiuser) { create(:apiuser) }
  let(:user)    { create(:user1) }

  let(:image_asset) do
    ActionDispatch::Http::UploadedFile.new(filename:     "sun.png",
                                           content_type: "image/png",
                                           tempfile:     File.new(File.join(fixture_path, "sun.png")))
  end

  let(:metadata) do
    { "visibility" => "department", "depositor" => user.email, "document_type_uri" => AICDocType.ConservationStillImage }
  end

  before do
    LakeshoreTesting.reset_uploads
    sign_in_basic(apiuser)
  end

  context "when uploading a file" do
    before { LakeshoreTesting.restore }
    it "successfully adds the fileset to the work" do
      expect(CharacterizeJob).to receive(:perform_later)
      post :create, asset_type: "StillImage", content: { intermediate: image_asset }, metadata: metadata
      expect(response).to be_accepted
    end
  end

  context "when the ingest is invalid" do
    before { post :create, asset_type: "StillImage" }
    subject { response }
    it { is_expected.to be_bad_request }
    its(:body) { is_expected.to eq("[\"Ingestor can't be blank\",\"Document type uri can't be blank\",\"Intermediate file can't be blank\"]") }
  end

  describe "asset type validation" do
    subject { response }

    context "when uploading a text asset to StillImage" do
      before do
        allow(AssetTypeVerificationService).to receive(:call).with("asset", AICType.StillImage).and_return(false)
        post :create, asset_type: "StillImage", content: { intermediate: "asset" }, metadata: metadata
      end
      it { is_expected.to be_bad_request }
      its(:body) { is_expected.to eq("[\"Intermediate file is not the correct asset type\"]") }
    end

    context "when uploading an image asset to Text" do
      before do
        allow(AssetTypeVerificationService).to receive(:call).with("asset", AICType.Text).and_return(false)
        post :create, asset_type: "Text", content: { intermediate: "asset" }, metadata: metadata
      end
      it { is_expected.to be_bad_request }
      its(:body) { is_expected.to eq("[\"Intermediate file is not the correct asset type\"]") }
    end
  end

  context "when uploading a duplicate file" do
    let(:duplicate_file) { double }
    subject { response }

    before do
      allow(AssetTypeVerificationService).to receive(:call).with("asset", AICType.StillImage).and_return(true)
      allow(controller).to receive(:duplicate_upload).and_return([duplicate_file])
      post :create, asset_type: "StillImage", content: { intermediate: "asset" }, metadata: metadata
    end
    its(:status) { is_expected.to eq(409) }
    its(:body) { is_expected.to start_with("[\"Intermediate file is a duplicate of") }
  end
end
