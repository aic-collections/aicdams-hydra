# frozen_string_literal: true
require 'rails_helper'

describe AddToCitiResourceActor do
  let(:user)     { create(:user1) }
  let(:asset)    { create(:asset) }
  let(:resource) { create(:non_asset) }
  let(:actor)    { CurationConcerns::Actors::ActorStack.new(asset, user, [described_class]) }

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

  describe "#create" do
    before  { actor.create(attributes) }
    subject { resource.reload }

    context "with no relationships" do
      let(:attributes) { {} }
      its(:representations) { is_expected.to be_empty }
    end

    context "with a representation" do
      let(:attributes) { { "representations_for" => [resource.id] } }

      before { resource.reload }

      it "assigns both representation and preferred representation" do
        expect(resource.representations).to contain_exactly(asset)
        expect(resource.preferred_representation).to eq(asset)
      end
    end

    context "with a preferred representation" do
      let(:attributes) { { "preferred_representation_for" => [resource.id] } }
      its(:preferred_representation) { is_expected.to eq(asset) }
    end
  end

  describe "#update" do
    let!(:other) { create(:asset) }
    let!(:na2)   { create(:non_asset, representations: [asset.uri], documents: [asset.uri]) }
    let!(:na1)   { create(:non_asset, representations: [asset.uri]) }
    let!(:na3)   { create(:non_asset, representations: [asset.uri, other.uri], preferred_representation: other.uri) }

    context "with multiple representations, documents, and a preferred representation" do
      let(:attributes) do
        {
          "representations_for" => [na2.id, na1.id],
          "documents_for" => [na1.id],
          "preferred_representation_for" => [na3.id]
        }
      end

      before { actor.update(attributes) }

      it "adds or removes the representations" do
        expect(na3.reload.representations).to contain_exactly(other, asset)
        expect(na3.reload.preferred_representation).to eq(asset)
        expect(na1.reload.representations).to eq([asset])
        expect(na1.reload.documents).to eq([asset])
        expect(na2.reload.representations).to eq([asset])
        expect(na2.reload.documents).to be_empty
      end

      describe "removing only representations" do
        let(:removal) { { "representations_for" => [], "documents_for" => [na1.id] } }

        before { actor.update(removal) }

        it "removes all representations and retains documents" do
          expect(na1.reload.documents).to eq([asset])
          expect(na1.reload.representations).to be_empty
          expect(na2.reload.representations).to be_empty
        end
      end
    end
  end

  describe "relationship attributes" do
    subject { described_class.new(nil, nil, nil) }

    before { subject.delete_relationship_attributes(attributes) }

    context "with no relationship attributes" do
      let(:attributes) { { "other_attribute" => "value" } }
      its(:representation_ids) { is_expected.to be_empty }
      its(:document_ids) { is_expected.to be_empty }
    end

    context "with some relationship attributes" do
      let(:attributes) do
        {
          other_attribute: "value",
          representations_for: ["x", "y"],
          additional_representation: "z",
          additional_document: "a"
        }
      end

      its(:representation_ids) { is_expected.to contain_exactly("x", "y", "z") }
      its(:document_ids) { is_expected.to eq(["a"]) }
    end
  end
end
