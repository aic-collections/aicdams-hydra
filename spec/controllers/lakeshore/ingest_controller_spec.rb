# frozen_string_literal: false
require 'rails_helper'

describe Lakeshore::IngestController do
  let(:apiuser)   { create(:apiuser) }
  let(:user)      { create(:user1) }
  let(:dept_user) { create(:department_user) }
  let(:image_asset) do
    ActionDispatch::Http::UploadedFile.new(filename:     "sun.png",
                                           content_type: "image/png",
                                           tempfile:     File.new(File.join(fixture_path, "sun.png")))
  end

  before do
    LakeshoreTesting.reset_uploads
    sign_in_basic(apiuser)
  end

  describe "#render_json_response is accessible" do
    it "includes CurationConcerns::ApplicationControllerBehavior" do
      expect(described_class.new).to be_kind_of(CurationConcerns::ApplicationControllerBehavior)
    end
  end

  describe "#create" do
    let(:metadata) do
      { "visibility" => "department", "depositor" => user.email, "document_type_uri" => AICDocType.ConservationStillImage }
    end

    context "when uploading a file" do
      before { LakeshoreTesting.restore }
      it "successfully adds the fileset to the work" do
        expect(Lakeshore::AttachFilesToWorkJob).to receive(:perform_later)
        post :create, asset_type: "StillImage", content: { intermediate: image_asset }, metadata: metadata
        expect(response).to be_accepted
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
      let(:file_set)      { build(:file_set, id: "existing-file-set-id") }
      let(:parent)        { build(:work, pref_label: "work pref_label") }
      let(:json_response) { JSON.parse(File.open(File.join(fixture_path, "api_409.json")).read).to_json }

      let(:metadata) do
        {
          "visibility" => "department",
          "depositor" => user.email,
          "document_type_uri" => AICDocType.ConservationStillImage,
          "uid" => "upload-id"
        }
      end

      subject { response }

      before do
        allow(AssetTypeVerificationService).to receive(:call).and_return(true)
        allow(controller).to receive(:duplicate_upload).and_return([file_set])
        allow(file_set).to receive(:parent).and_return(parent)
        post :create, asset_type: "StillImage", content: { intermediate: image_asset }, metadata: metadata
      end

      its(:status) { is_expected.to eq(409) }
      its(:body) { is_expected.to eq(json_response) }
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
  end

  describe "#update with no duplicates" do
    let(:metadata) { { "depositor" => user.email } }
    let(:parent) { build(:work, pref_label: "work pref_label") }

    let(:replacement_asset) do
      ActionDispatch::Http::UploadedFile.new(filename:     "tardis.png",
                                             content_type: "image/png",
                                             tempfile:     File.new(File.join(fixture_path, "tardis.png")))
    end

    before do
      LakeshoreTesting.restore
      allow(Lakeshore::CreateAllDerivatives).to receive(:perform_later)
      allow(controller).to receive(:duplicate_upload).and_return([])
    end

    context "with an intermediate file" do
      subject { asset.intermediate_file_set.first }

      context "when one does not exist" do
        let(:asset) { create(:asset) }

        before do
          post :update, id: asset.id, content: { intermediate: image_asset }, metadata: metadata
          asset.reload
        end

        its(:title) { is_expected.to eq(["sun.png"]) }
      end

      context "when one already exists" do
        let(:asset)    { create(:asset, :with_intermediate_file_set) }
        let(:file_set) { build(:file_set, id: "existing-file-set-id") }
        let(:duplicate_check_param) { "true" }

        before do
          post :update, id: asset.id, content: { intermediate: replacement_asset }, metadata: metadata, duplicate_check: duplicate_check_param
          asset.reload
        end

        its(:title) { is_expected.to eq(["tardis.png"]) }

        context "when the depositor is another user in the asset depositor's department" do
          let(:metadata) { { "depositor" => dept_user.email } }

          it "returns a 202" do
            expect(response).to have_http_status(202)
          end

          it "does not change asset's depositor" do
            expect(asset.depositor).to eq("user1")
          end

          it "changes the file_set's depositor" do
            expect(asset.intermediate_file_set.first.depositor).to eq("department_user")
          end
        end

        context "and is a duplicate" do
          let(:parent) { build(:work, pref_label: "work pref_label") }

          before do
            allow(controller).to receive(:duplicate_upload).and_return([file_set])
            allow(file_set).to receive(:parent).and_return(parent)
            post :update, id: asset.id, content: { intermediate: replacement_asset }, metadata: metadata, duplicate_check: duplicate_check_param
            asset.reload
          end

          context "when duplicate_check param is false" do
            let(:duplicate_check_param) { "false" }
            it "returns a 202" do
              expect(response).to have_http_status(202)
            end
          end

          context "when duplicate_check param is true" do
            let(:duplicate_check_param) { "true" }
            it "returns a 409" do
              expect(response).to have_http_status(409)
            end
          end
        end
      end
    end

    context "with an original file" do
      subject { asset.original_file_set.first }

      context "when none exists" do
        let(:asset) { create(:asset) }

        before do
          post :update, id: asset.id, content: { original: image_asset }, metadata: metadata
          asset.reload
        end

        its(:title) { is_expected.to eq(["sun.png"]) }
      end

      context "when one already exists" do
        let(:asset) { create(:asset, :with_original_file_set) }

        before do
          post :update, id: asset.id, content: { original: replacement_asset }, metadata: metadata
          asset.reload
        end

        it "replaces the file" do
          expect(subject.characterization_proxy.file_name).to eq(["tardis.png"])
        end
      end
    end

    context "with a preservation master file" do
      subject { asset.preservation_file_set.first }

      context "when none exists" do
        let(:asset) { create(:asset) }

        before do
          post :update, id: asset.id, content: { pres_master: image_asset }, metadata: metadata
          asset.reload
        end

        its(:title) { is_expected.to eq(["sun.png"]) }
      end

      context "when one already exists" do
        let(:asset) { create(:asset, :with_preservation_file_set) }

        before do
          post :update, id: asset.id, content: { pres_master: replacement_asset }, metadata: metadata
          asset.reload
        end

        it "replaces the file" do
          expect(subject.characterization_proxy.file_name).to eq(["tardis.png"])
        end
      end
    end

    context "with a legacy file" do
      subject { asset.legacy_file_set.first }

      context "when none exists" do
        let(:asset) { create(:asset) }

        before do
          post :update, id: asset.id, content: { legacy: image_asset }, metadata: metadata
          asset.reload
        end

        its(:title) { is_expected.to eq(["sun.png"]) }
      end

      context "when one already exists" do
        let(:asset) { create(:asset, :with_legacy_file_set) }

        before do
          post :update, id: asset.id, content: { legacy: replacement_asset }, metadata: metadata
          asset.reload
        end

        it "replaces the file" do
          expect(subject.characterization_proxy.file_name).to eq(["tardis.png"])
        end
      end
    end
  end
end
