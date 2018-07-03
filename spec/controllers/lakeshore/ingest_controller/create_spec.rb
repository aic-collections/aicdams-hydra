# frozen_string_literal: false
require 'rails_helper'

describe Lakeshore::IngestController, custom_description: "Lakeshore::IngestController#create" do
  let(:apiuser) { create(:apiuser) }
  let(:user)    { create(:user1) }

  # bang this so it is not memoized and gets invoked even after tmp dir is wiped via LakeshoreTesting
  # https://cits.artic.edu/issues/2943
  let!(:image_asset) do
    ActionDispatch::Http::UploadedFile.new(filename:     "sun.png",
                                           content_type: "image/png",
                                           tempfile:     File.new(File.join(fixture_path, "sun.png")))
  end

  before { sign_in_basic(apiuser) }

  let(:metadata) do
    { "visibility" => "department", "depositor" => user.email, "document_type_uri" => AICDocType.ConservationStillImage }
  end

  context "when uploading a file" do
    before { LakeshoreTesting.restore }
    it "successfully adds the fileset to the work" do
      expect(Lakeshore::AttachFilesToWorkJob).to receive(:perform_later)
      post :create, asset_type: "StillImage", content: { intermediate: image_asset }, metadata: metadata
      expect(response).to be_accepted
      expect(Sufia::UploadedFile.all.first.status).to eq("begun_ingestion")
    end
  end

  context "when uploading with additional fields" do
    let(:metadata) do
      {
        "visibility" => "department",
        "depositor" => user.email,
        "document_type_uri" => AICDocType.ConservationStillImage,
        "uid" => "SI-99",
        "created" => "July 19, 1934",
        "updated" => "July 21, 1936",
        "batch_uid" => "1234"
      }
    end
    let(:asset) { GenericWork.where(uid: "SI-99").first }

    before { LakeshoreTesting.restore }

    it "successfully creates the the work" do
      expect(Lakeshore::AttachFilesToWorkJob).to receive(:perform_later)
      post :create, asset_type: "StillImage", content: { intermediate: image_asset }, metadata: metadata
      expect(response).to be_accepted
      expect(asset.created).to eq(Date.parse("July 19, 1934"))
      expect(asset.updated).to eq(Date.parse("July 21, 1936"))
      expect(asset.batch_uid).to eq("1234")
    end
  end

  context "when the ingest is invalid" do
    before { post :create, asset_type: "StillImage" }
    subject { response }
    it { is_expected.to be_bad_request }
    its(:body) { is_expected.to eq("[\"Ingestor can't be blank\",\"Document type uri can't be blank\",\"Intermediate file can't be blank\"]") }
  end

  context 'with an unsupported file set type' do
    it "returns an error" do
      post :create, asset_type: "StillImage",
                    content: { intermediate: image_asset, bogus: image_asset },
                    metadata: metadata
      expect(response).to be_bad_request
      expect(response.body).to eq("[\"Registry Files Request contains invalid file types: bogus\"]")
    end
  end

  describe "asset type validation" do
    subject { response }

    context "when uploading a text asset to StillImage" do
      before do
        allow(AssetTypeVerificationService).to receive(:call)
          .with(kind_of(Lakeshore::IngestFile), AICType.StillImage)
          .and_return(false)
        post :create, asset_type: "StillImage", content: { intermediate: image_asset }, metadata: metadata
      end
      it { is_expected.to be_bad_request }
      its(:body) { is_expected.to eq("[\"Intermediate file is not the correct asset type\"]") }
    end

    context "when uploading an image asset to Text" do
      before do
        allow(AssetTypeVerificationService).to receive(:call)
          .with(kind_of(Lakeshore::IngestFile), AICType.Text)
          .and_return(false)
        post :create, asset_type: "Text", content: { intermediate: image_asset }, metadata: metadata
      end
      it { is_expected.to be_bad_request }
      its(:body) { is_expected.to eq("[\"Intermediate file is not the correct asset type\"]") }
    end
  end

  context "when the ingestor does not exist in Fedora" do
    let(:metadata) do
      { "visibility" => "department", "depositor" => "bogus", "document_type_uri" => AICDocType.ConservationStillImage }
    end

    subject { response }

    before { post :create, asset_type: "StillImage", content: { intermediate: image_asset }, metadata: metadata }

    it { is_expected.to be_bad_request }
    its(:body) { is_expected.to eq("[\"Ingestor can't be blank\"]") }
  end

  context "when a provided CITI resource already has a preferred representation" do
    let(:metadata) do
      {
        "visibility" => "department",
        "depositor" => user.email,
        "document_type_uri" => AICDocType.ConservationStillImage,
        "preferred_representation_for" => ["resource"]
      }
    end

    subject { response }

    before do
      allow(controller).to receive(:validate_duplicate_upload)
      allow(controller).to receive(:represented_resources).and_return(["resource"])
      post :create, asset_type: "StillImage", content: { intermediate: image_asset }, metadata: metadata
    end

    its(:body) { is_expected.to eq("[\"Represented resources resource already have a preferred representation\"]") }
  end

  context "when adding a new preferred representations" do
    let(:non_asset) { create(:non_asset) }

    let(:metadata) do
      {
        "visibility" => "department",
        "depositor" => user.email,
        "document_type_uri" => AICDocType.ConservationStillImage,
        "preferred_representation_for" => [non_asset.id]
      }
    end

    before { LakeshoreTesting.restore }

    it "updates the non_asset with the preferred representation" do
      expect(Lakeshore::AttachFilesToWorkJob).to receive(:perform_later)
      expect(non_asset.preferred_representation_uri).to be_nil
      post :create, asset_type: "StillImage", content: { intermediate: image_asset }, metadata: metadata
      expect(response).to be_accepted
      non_asset.reload
      expect(non_asset.preferred_representation_uri).to eq(GenericWork.all.first.uri.to_s)
      expect(non_asset.representation_uris).to contain_exactly(GenericWork.all.first.uri.to_s)
    end
  end

  context "with an existing preferred representation" do
    let(:asset) { create(:asset) }
    let(:non_asset) { create(:non_asset, preferred_representation_uri: asset.uri) }

    let(:metadata) do
      {
        "visibility" => "department",
        "depositor" => user.email,
        "document_type_uri" => AICDocType.ConservationStillImage,
        "preferred_representation_for" => [non_asset.id]
      }
    end

    it "returns an error leaving the original relationship unchanged" do
      pending("until we reimplement file_set api in https://cits.artic.edu/issues/2963")
      expect(Lakeshore::AttachFilesToWorkJob).not_to receive(:perform_later)
      post :update, id: asset.id, metadata: metadata
      expect(response.status).to eq(409)
      expect(non_asset.preferred_representation_uri).to eq(asset.uri)
    end
  end

  context "when forcing the update of an existing preferred representation" do
    let(:asset) { create(:asset) }
    let(:non_asset) { create(:non_asset, preferred_representation_uri: asset.uri) }

    let(:metadata) do
      {
        "visibility" => "department",
        "depositor" => user.email,
        "document_type_uri" => AICDocType.ConservationStillImage,
        "preferred_representation_for" => [non_asset.id]
      }
    end

    before { LakeshoreTesting.restore }

    it "updates the non_asset with the new preferred representation" do
      expect(Lakeshore::AttachFilesToWorkJob).to receive(:perform_later)
      expect(non_asset.preferred_representation_uri).to eq(asset.uri)
      post :create, asset_type: "StillImage",
                    content: { intermediate: image_asset },
                    metadata: metadata,
                    force_preferred_representation: "true"
      expect(response).to be_accepted
      non_asset.reload
      expect(non_asset.preferred_representation_uri).not_to eq(asset.uri)
    end
  end
end
