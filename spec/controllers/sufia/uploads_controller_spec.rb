# frozen_string_literal: true
require 'rails_helper'

describe Sufia::UploadsController do
  routes { Sufia::Engine.routes }
  include_context "authenticated saml user"

  let(:duplicates) { [] }
  # before { allow(controller).to receive(:duplicate_upload).and_return(duplicates) }

  describe "uploading a single asset" do
    before { post :create, files: [file], generic_work: work_attributes, format: 'json' }

    context "with a valid still image" do
      let(:file) { create(:image_file) }
      let(:work_attributes) { { "asset_type" => AICType.StillImage.to_s, "use_uri" => AICType.IntermediateFileSet.to_s } }
      it "successfully uploads the file" do
        expect(response).to be_success
        expect(assigns(:upload)).to be_kind_of Sufia::UploadedFile
        expect(assigns(:upload)).to be_persisted
      end
    end

    context "with an invalid still image" do
      let(:file)            { create(:text_file) }
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
      let(:file) { create(:image_file) }
      let(:work_attributes) { { "asset_type" => AICType.StillImage.to_s, "use_uri" => AICType.IntermediateFileSet.to_s } }

      it "successfully uploads the file" do
        expect(response).to be_success
        expect(assigns(:upload)).to be_kind_of Sufia::UploadedFile
        expect(assigns(:upload)).to be_persisted
      end
    end

    context "with an invalid still image" do
      let(:file)            { create(:text_file) }
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

  describe "updating the use uri" do
    routes { Rails.application.routes }

    let!(:user)          { create(:user1) }
    # let!(:file)          { File.open(File.join(fixture_path, "sun.png")) }
    let!(:file)          { create(:image_file) }
    let!(:uploaded_file) { create(:uploaded_file) }

    subject { uploaded_file.reload }

    before { put :update, id: uploaded_file.id, use_uri: AICType.IntermediateFileSet }
    its(:use_uri) { is_expected.to eq(AICType.IntermediateFileSet) }
  end
end
