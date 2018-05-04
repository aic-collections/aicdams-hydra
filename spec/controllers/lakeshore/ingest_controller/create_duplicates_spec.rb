# frozen_string_literal: false
require 'rails_helper'

describe Lakeshore::IngestController, custom_description: "Lakeshore::IngestController#create" do
  let(:apiuser)  { create(:apiuser) }
  let(:user)     { create(:user1) }
  let(:file_set) { build(:file_set, id: "existing-file-set-id") }
  let(:parent)   { build(:work, pref_label: "work pref_label") }

  let(:image_asset) do
    ActionDispatch::Http::UploadedFile.new(filename:     "sun.png",
                                           content_type: "image/png",
                                           tempfile:     File.new(File.join(fixture_path, "sun.png")))
  end

  context "when uploading a duplicate file" do
    let(:json_response) { JSON.parse(File.open(File.join(fixture_path, "api_409.json")).read).to_json }

    let(:metadata) do
      {
        "visibility" => "department",
        "depositor" => user.email,
        "document_type_uri" => AICDocType.ConservationStillImage,
        "uid" => "upload-id"
      }
    end

    before do
      sign_in_basic(apiuser)
      allow(AssetTypeVerificationService).to receive(:call).and_return(true)
      allow(file_set).to receive(:parent).and_return(parent)
      allow_any_instance_of(ChecksumValidator).to receive(:duplicate_file_sets).and_return([file_set])
      post :create, asset_type: "StillImage", content: { intermediate: image_asset }, metadata: metadata
    end

    it "returns an error with the correct status" do
      expect(response.status).to eq(409)
      expect(response.body).to eq(json_response)
    end
  end
end
