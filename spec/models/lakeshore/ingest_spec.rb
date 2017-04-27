# frozen_string_literal: true
require 'rails_helper'

describe Lakeshore::Ingest do
  let(:user)              { create(:user1) }
  let(:controller_params) { ActionController::Parameters.new(params) }
  let(:ingest)            { described_class.new(controller_params) }

  describe "#valid?" do
    subject { ingest }

    context "when the ingest has all the required data" do
      let(:params) do
        {
          asset_type: "StillImage",
          content: { intermediate: "file_set" },
          metadata: { document_type_uri: "doc_type", depositor: user.email }
        }
      end
      it { is_expected.to be_valid }
      it { is_expected.to be_check_duplicates }
    end

    context "when not checking for duplicates" do
      let(:params) do
        {
          asset_type: "StillImage",
          content: { intermediate: "file_set" },
          metadata: { document_type_uri: "doc_type", depositor: user.email },
          duplicate_check: "false"
        }
      end
      it { is_expected.not_to be_check_duplicates }
    end
  end

  describe "#valid_update?" do
    let(:params) do
      { metadata: { action: "update", depositor: user.email } }
    end

    subject { ingest }

    it { is_expected.to be_valid_update }
  end

  describe "#errors" do
    before { ingest.validate }

    subject { ingest.errors }

    context "without the required parameters" do
      let(:params) { { asset_type: "StillImage" } }
      its(:full_messages) { is_expected.to contain_exactly("Ingestor can't be blank", "Document type uri can't be blank") }
    end

    context "with a bad asset type" do
      let(:params) { { asset_type: "BadType" } }
      its(:full_messages) { is_expected.to include("Asset type BadType is not a registered asset type") }
    end
  end

  describe "#files" do
    let(:params) do
      {
        asset_type: "StillImage",
        content: content,
        metadata: { document_type_uri: "doc_type", depositor: user.email }
      }
    end

    subject do
      described_class.new(controller_params).files.map do |id|
        Sufia::UploadedFile.find(id).use_uri
      end
    end

    context "with only an intermediate file" do
      let(:content) { { intermediate: "intermediate file_set" } }
      it { is_expected.to contain_exactly(AICType.IntermediateFileSet) }
    end

    context "with original, intermediate, legacy, and preservation files" do
      let(:content) do
        { original: "original file_set", pres_master: "preservation master file_set", intermediate: "intermediate file_set", legacy: "legacy file_set" }
      end
      it { is_expected.to contain_exactly(AICType.OriginalFileSet,
                                          AICType.IntermediateFileSet,
                                          AICType.PreservationMasterFileSet,
                                          AICType.LegacyFileSet) }
    end

    context "with assorted other files" do
      let(:content) do
        { "intermediate" => "intermediate file_set", "0" => "oddball 0", "1" => "oddball 1", "other" => "other" }
      end

      it { is_expected.to contain_exactly(AICType.IntermediateFileSet, nil, nil, nil) }
    end
  end

  describe "#attributes_for_actor" do
    subject { ingest.attributes_for_actor }

    context "without additional sharing permissions" do
      let(:params) do
        {
          asset_type: "StillImage",
          content: { intermediate: "file_set" },
          metadata: { document_type_uri: "doc_type", depositor: user.email }
        }
      end

      it { is_expected.to include(asset_type: AICType.StillImage,
                                  document_type_uri: "doc_type",
                                  permissions_attributes: [],
                                  ingest_method: "api",
                                  uploaded_files: ["1"])}
    end

    context "with custom sharing permissions" do
      let(:params) do
        {
          asset_type: "StillImage",
          content: { intermediate: "file_set" },
          metadata: { document_type_uri: "doc_type", depositor: user.email },
          sharing: '[{ "type" : "group", "name" : "112", "access" : "read" }, {"type" : "person", "name" : "jdoe99", "access" : "edit"}]'
        }
      end

      it { is_expected.to include(asset_type: AICType.StillImage,
                                  document_type_uri: "doc_type",
                                  permissions_attributes: [
                                    { type: "group",  name: "112",    access: "read" },
                                    { type: "person", name: "jdoe99", access: "edit" }
                                  ],
                                  uploaded_files: ["1"])}
    end

    context "when specifying additional permissions for the depositor" do
      subject { ingest.attributes_for_actor[:permissions_attributes] }

      let(:params) do
        {
          asset_type: "StillImage",
          content: { intermediate: "file_set" },
          metadata: { document_type_uri: "doc_type", depositor: user.email },
          sharing: '[{ "type" : "group", "name" : "112", "access" : "read" }, {"type" : "person", "name" : "' + user.email + '", "access" : "edit"}]'
        }
      end

      it { is_expected.to contain_exactly(type: "group", name: "112", access: "read") }
    end
  end

  describe "#represented_resources" do
    let(:params) do
      {
        asset_type: "StillImage",
        content: { intermediate: "file_set" },
        metadata: { document_type_uri: "doc_type", depositor: user.email }
      }
    end

    subject { ingest }

    context "when no preferred representations are specified" do
      let(:params) do
        {
          asset_type: "StillImage",
          content: { intermediate: "file_set" },
          metadata: { document_type_uri: "doc_type", depositor: user.email }
        }
      end

      its(:represented_resources) { is_expected.to be_empty }
    end

    context "when specifying a resource that already has a preferred representation" do
      let(:asset)    { create(:asset) }
      let(:resource) { create(:work, preferred_representation_uri: asset.uri) }
      let(:params) do
        {
          asset_type: "StillImage",
          content: { intermediate: "file_set" },
          metadata: { document_type_uri: "doc_type", depositor: user.email, preferred_representation_for: [resource.id] }
        }
      end

      its(:represented_resources) { is_expected.to contain_exactly(resource.id) }
    end

    context "when specifying a resource that does not have a preferred representation" do
      let(:resource) { create(:work) }
      let(:params) do
        {
          asset_type: "StillImage",
          content: { intermediate: "file_set" },
          metadata: { document_type_uri: "doc_type", depositor: user.email, preferred_representation_for: [resource.id] }
        }
      end

      its(:represented_resources) { is_expected.to be_empty }
    end
  end
end
