# frozen_string_literal: true
require 'rails_helper'

describe Sufia::UploadsController do
  routes { Sufia::Engine.routes }
  include_context "authenticated saml user"

  describe "uploading a single asset" do
    before { post :create, files: [file], generic_work: work_attributes, format: 'json' }

    context "with a valid still image" do
      let(:file) { fixture_file_upload('sun.png', 'image/png') }
      let(:work_attributes) { { "asset_type" => AICType.StillImage.to_s } }
      it "successfully uploads the file" do
        expect(response).to be_success
        expect(assigns(:upload)).to be_kind_of Sufia::UploadedFile
        expect(assigns(:upload)).to be_persisted
      end
    end

    context "with an invalid still image" do
      let(:file)            { fixture_file_upload('text.txt', 'text/plain') }
      let(:work_attributes) { { "asset_type" => AICType.StillImage.to_s } }
      let(:error) { "{\"files\":[{\"error\":\"Incorrect asset type. text.txt is not a type of still image\"}]}" }
      it "reports an asset type error" do
        expect(response).to be_success
        expect(assigns(:upload)).to be_kind_of Sufia::UploadedFile
        expect(assigns(:upload)).not_to be_persisted
        expect(response.body).to eq(error)
      end
    end
  end

  describe "uploading a batch item" do
    before { post :create, files: [file], batch_upload_item: work_attributes, format: 'json' }

    context "with a valid still image" do
      let(:file) { fixture_file_upload('sun.png', 'image/png') }
      let(:work_attributes) { { "asset_type" => AICType.StillImage.to_s } }
      it "successfully uploads the file" do
        expect(response).to be_success
        expect(assigns(:upload)).to be_kind_of Sufia::UploadedFile
        expect(assigns(:upload)).to be_persisted
      end
    end

    context "with an invalid still image" do
      let(:file)            { fixture_file_upload('text.txt', 'text/plain') }
      let(:work_attributes) { { "asset_type" => AICType.StillImage.to_s } }
      let(:error) { "{\"files\":[{\"error\":\"Incorrect asset type. text.txt is not a type of still image\"}]}" }
      it "reports an asset type error" do
        expect(response).to be_success
        expect(assigns(:upload)).to be_kind_of Sufia::UploadedFile
        expect(assigns(:upload)).not_to be_persisted
        expect(response.body).to eq(error)
      end
    end
  end
end
