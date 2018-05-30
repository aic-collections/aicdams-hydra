# frozen_string_literal: true
require 'rails_helper'

describe Lakeshore::Ingest do
  let(:user)              { create(:user1) }
  let(:controller_params) { ActionController::Parameters.new(params) }
  let(:ingest)            { described_class.new(controller_params) }
  let(:file)              { File.open(File.join(fixture_path, "sun.png")) }
  let(:file0)             { File.open(File.join(fixture_path, "tardis.png")) }
  let(:file1)             { File.open(File.join(fixture_path, "tardis2.png")) }
  let(:file2)             { File.open(File.join(fixture_path, "text.png")) }

  before { LakeshoreTesting.restore }

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
      it "#check_duplicates_turned_off? is false" do
        expect(subject.check_duplicates_turned_off?).to be(false)
      end
    end

    context "duplicate_check is set to 'true'" do
      let(:params) do
        {
          asset_type: "StillImage",
          content: { intermediate: "file_set" },
          metadata: { document_type_uri: "doc_type", depositor: user.email },
          duplicate_check: "false"
        }
      end
      it "#check_duplicates_turned_off? is true" do
        expect(subject.check_duplicates_turned_off?).to be(true)
      end
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
      its(:full_messages) { is_expected.to contain_exactly("Ingestor can't be blank",
                                                           "Document type uri can't be blank",
                                                           "Intermediate file can't be blank") }
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
      let(:content) { { intermediate: file } }
      it { is_expected.to contain_exactly(AICType.IntermediateFileSet) }
    end

    context "with original, intermediate, legacy, and preservation files" do
      let(:content) do
        { original: file, pres_master: file0, intermediate: file1, legacy: file2 }
      end
      it { is_expected.to contain_exactly(AICType.OriginalFileSet,
                                          AICType.IntermediateFileSet,
                                          AICType.PreservationMasterFileSet,
                                          AICType.LegacyFileSet) }
    end

    context "with assorted other files" do
      let(:content) do
        { "intermediate" => file, "odd0" => file0, "odd1" => file1, "odd2" => file2 }
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
          content: { intermediate: file },
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
          content: { intermediate: file },
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
          content: { intermediate: file },
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

  describe "#force_preferred_representation?" do
    subject { ingest.force_preferred_representation? }

    context "by default" do
      let(:params) { {} }
      it { is_expected.to be(false) }
    end

    context "when set to false" do
      let(:params) { { force_preferred_representation: "false" } }
      it { is_expected.to be(false) }
    end

    context "when set to true" do
      let(:params) { { force_preferred_representation: "true" } }
      it { is_expected.to be(true) }
    end

    context "when set to anything" do
      let(:params) { { force_preferred_representation: "asdf" } }
      it { is_expected.to be(false) }
    end
  end
end
