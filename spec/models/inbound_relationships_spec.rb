# frozen_string_literal: true
require 'rails_helper'

describe InboundRelationships do
  let!(:asset)                    { create(:asset) }
  let!(:document)                 { create(:exhibition, documents: [asset]) }
  let!(:representation)           { create(:exhibition, representations: [asset]) }
  let!(:preferred_representation) { create(:exhibition, preferred_representation: asset) }

  context "with an asset contain all the types of relationships" do
    let(:relationships) { described_class.new(asset) }
    it "maps all incomming relationships to the asset" do
      expect(relationships.documents).to eq([document])
      expect(relationships.document_ids).to eq([document.id])
      expect(relationships.representations).to eq([representation])
      expect(relationships.representation_ids).to eq([representation.id])
      expect(relationships.preferred_representations).to eq([preferred_representation])
      expect(relationships.preferred_representation_ids).to eq([preferred_representation.id])
      expect(relationships.present?).to be true
      expect(relationships.ids).to contain_exactly(document.id, representation.id, preferred_representation.id)
    end
  end

  context "with an asset containing no relationships" do
    let(:empty_asset) { create(:asset) }
    let(:relationships) { described_class.new(empty_asset) }
    it "maps all relationships as empty" do
      expect(relationships.documents).to be_empty
      expect(relationships.document_ids).to be_empty
      expect(relationships.representations).to be_empty
      expect(relationships.representation_ids).to be_empty
      expect(relationships.preferred_representations).to be_empty
      expect(relationships.preferred_representation_ids).to be_empty
      expect(relationships.present?).to be false
      expect(relationships.ids).to be_empty
    end
  end
end
