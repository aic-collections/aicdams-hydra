# frozen_string_literal: true
require 'rails_helper'

describe AddToCitiResourceActor do
  let(:user)     { create(:user1) }
  let(:asset)    { create(:asset) }
  let(:resource) { create(:exhibition) }
  let(:actor)    { CurationConcerns::Actors::ActorStack.new(asset, user, [described_class]) }

  describe "#create" do
    before  { actor.create(attributes) }
    subject { resource.reload }

    context "with no relationships" do
      let(:attributes) { {} }
      its(:representations) { is_expected.to be_empty }
    end

    context "with a representation" do
      let(:attributes) do
        { "representations_for" => [resource.id] }
      end
      its(:representations) { is_expected.to include(asset) }
    end
  end

  describe "#update" do
    let!(:other)      { create(:asset) }
    let!(:work)       { create(:work, representations: [asset], documents: [asset]) }
    let!(:exhibition) { create(:exhibition, representations: [asset]) }
    let!(:shipment)   { create(:shipment, representations: [asset, other]) }

    context "with multiple representations and documents" do
      let(:attributes) do
        { "representations_for" => [work.id, exhibition.id], "documents_for" => [exhibition.id] }
      end

      before { actor.update(attributes) }

      it "adds or removes the representations" do
        expect(shipment.reload.representations).to eq([other])
        expect(exhibition.reload.representations).to eq([asset])
        expect(exhibition.reload.documents).to eq([asset])
        expect(work.reload.representations).to eq([asset])
        expect(work.reload.documents).to be_empty
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
      it { is_expected.not_to be_related }
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
      it { is_expected.to be_related }
    end
  end
end
