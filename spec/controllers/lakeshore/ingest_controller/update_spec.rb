# frozen_string_literal: false
require 'rails_helper'

describe Lakeshore::IngestController, custom_description: "Lakeshore::IngestController#update" do
  let(:apiuser) { create(:apiuser) }
  let(:user)    { create(:user1) }

  # bang this so it is not memoized and gets invoked even after tmp dir is wiped via LakeshoreTesting
  # https://cits.artic.edu/issues/2943
  let!(:image_asset) do
    ActionDispatch::Http::UploadedFile.new(filename:     "sun.png",
                                           content_type: "image/png",
                                           tempfile:     File.new(File.join(fixture_path, "sun.png")))
  end

  # bang this so it is not memoized and gets invoked even after tmp dir is wiped via LakeshoreTesting
  # https://cits.artic.edu/issues/2943
  let!(:replacement_asset) do
    ActionDispatch::Http::UploadedFile.new(filename:     "tardis.png",
                                           content_type: "image/png",
                                           tempfile:     File.new(File.join(fixture_path, "tardis.png")))
  end

  before do
    sign_in_basic(apiuser)
    LakeshoreTesting.restore
  end

  describe "replacing files" do
    let(:metadata) { { "depositor" => user.email } }

    before do
      LakeshoreTesting.restore
      allow(Lakeshore::CreateAllDerivatives).to receive(:perform_later)
      allow(controller).to receive(:duplicate_upload).and_return([])
    end

    context "with an intermediate file" do
      subject { asset.intermediate_file_set.first }

      context "when none exists" do
        let(:asset) { create(:asset) }

        before do
          post :update, id: asset.id, content: { intermediate: image_asset }, metadata: metadata
          asset.reload
        end

        its(:title) { is_expected.to eq(["sun.png"]) }
      end

      context "when one already exists" do
        let(:asset) { create(:asset, :with_intermediate_file_set) }

        before do
          post :update, id: asset.id, content: { intermediate: replacement_asset }, metadata: metadata
          asset.reload
        end

        its(:title) { is_expected.to eq(["tardis.png"]) }
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

  describe "replacing duplicate files" do
    let(:metadata) { { "depositor" => user.email } }
    let(:asset)    { create(:asset, :with_intermediate_file_set) }
    let(:file_set) { build(:file_set, id: "existing-file-set-id") }
    let(:parent)   { build(:work, pref_label: "work pref_label") }

    before do
      allow(Lakeshore::CreateAllDerivatives).to receive(:perform_later)
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

  describe "updating preferred representations" do
    let(:asset) { create(:asset) }

    context "with no existing representations" do
      let(:non_asset) { create(:non_asset) }

      let(:metadata) do
        {
          "depositor" => user.email,
          "preferred_representation_for" => [non_asset.id]
        }
      end

      it "updates the relationships" do
        post :update, id: asset.id, metadata: metadata
        non_asset.reload
        expect(non_asset.preferred_representation_uri).to eq(asset.uri.to_s)
        expect(non_asset.representation_uris).to contain_exactly(asset.uri.to_s)
      end
    end

    context "with an existing preferred representation" do
      let(:non_asset) { create(:non_asset, preferred_representation_uri: asset.uri) }

      let(:metadata) do
        {
          "depositor" => user.email,
          "preferred_representation_for" => [non_asset.id]
        }
      end

      it "returns an error" do
        post :update, id: asset.id, metadata: metadata
        expect(response.status).to eq(409)
      end
    end

    context "when forcing the update of an existing preferred representation" do
      let(:non_asset) { create(:non_asset, preferred_representation_uri: asset.uri) }

      let(:metadata) do
        {
          "depositor" => user.email,
          "preferred_representation_for" => [non_asset.id]
        }
      end

      it "updates the relationships" do
        post :update, id: asset.id, metadata: metadata, force_preferred_representation: "true"
        non_asset.reload
        expect(non_asset.preferred_representation_uri).to eq(asset.uri.to_s)
        expect(non_asset.representation_uris).to contain_exactly(asset.uri.to_s)
      end
    end
  end
end
