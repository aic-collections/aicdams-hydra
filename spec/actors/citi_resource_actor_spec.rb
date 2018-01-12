# frozen_string_literal: true
require 'rails_helper'

describe CitiResourceActor do
  let(:user)               { create(:user1) }
  let(:asset1)             { create(:asset) }
  let(:asset2)             { create(:asset) }
  let(:intermediate_asset) { create(:asset, :with_intermediate_file_set) }
  let(:actor)              { CurationConcerns::Actors::ActorStack.new(non_asset, user, [described_class]) }

  before do
    Rails.application.routes.draw do
      namespace :curation_concerns, path: :concern do
        resources :non_assets
        mount Sufia::Engine => '/'
      end
    end
  end

  after do
    Rails.application.reload_routes!
  end

  describe "#update" do
    context "with identical attributes passed in" do
      let!(:attributes) { { "representation_uris" => [asset1.uri.to_s], preferred_representation_uri: asset1.uri.to_s } }
      let!(:non_asset) { create(:non_asset, attributes) }

      it "does not change the attributes" do
        actor.update(attributes)
        expect(non_asset).to have_attributes(attributes)
      end

      it "does not notify CITI" do
        expect(CitiNotificationJob).not_to receive(:perform_later)
        actor.update(attributes)
      end
    end

    context "when the asset's updated preferred representation does not have an intermediate file set" do
      let!(:non_asset) { create(:non_asset, preferred_representation_uri: asset1.uri) }

      it "does not notify CITI" do
        expect(CitiNotificationJob).not_to receive(:perform_later)
        actor.update("preferred_representation_uri" => asset2.uri.to_s)
        expect(non_asset.preferred_representation_uri).to eq(asset2.uri.to_s)
      end
    end

    context "when the asset's updated preferred representation has an intermediate file set" do
      let!(:non_asset) { create(:non_asset, preferred_representation_uri: asset1.uri) }

      it "notifies CITI" do
        expect(CitiNotificationJob).to receive(:perform_later)
        actor.update("preferred_representation_uri" => intermediate_asset.uri.to_s)
        expect(non_asset.preferred_representation_uri).to eq(intermediate_asset.uri)
      end
    end

    context "when removing the preferred representation when there are normal representations" do
      let!(:non_asset) { create(:non_asset, representation_uris: [intermediate_asset.uri.to_s], preferred_representation_uri: intermediate_asset.uri.to_s) }

      it "makes the first normal representation, the preferred representation" do
        actor.update(representation_uris: [asset1.uri.to_s], preferred_representation_uri: "")
        expect(non_asset.preferred_representation_uri).to eq(non_asset.representation_uris.first)
      end

      it "notifies CITI" do
        expect(CitiNotificationJob).to receive(:perform_later)
        actor.update("preferred_representation_uri" => "")
        expect(non_asset.preferred_representation_uri).to be_nil
      end
    end

    context "when adding a preferred representation that is not a normal representations" do
      let!(:non_asset) { create(:non_asset, representation_uris: [asset1.uri.to_s, asset2.uri.to_s], preferred_representation_uri: "") }

      it "adds the preferred representation as a normal representation" do
        actor.update(representation_uris: [asset1.uri.to_s], "preferred_representation_uri" => asset2.uri.to_s)
        expect(non_asset.representation_uris).to include(asset2.uri.to_s)
      end

      it "notifies CITI" do
        expect(CitiNotificationJob).to receive(:perform_later)
        actor.update("preferred_representation_uri" => intermediate_asset.uri.to_s)
      end
    end

    context "when user removes the only normal representation with intermediate file set, but leaving it as a preferred representation" do
      let!(:non_asset) { create :non_asset, representation_uris: [intermediate_asset.uri.to_s], preferred_representation_uri: intermediate_asset.uri.to_s }

      it "the developer should use javascript because the params are identical to another context" do
      end
    end
  end
end
