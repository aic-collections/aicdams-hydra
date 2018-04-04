# frozen_string_literal: true
require 'rails_helper'

describe InboundRelationships do
  let!(:attachment)               { create(:asset) }
  let!(:constituent)              { create(:asset) }
  let!(:asset)                    { create(:asset, attachments: [attachment.uri],
                                                   constituent_of: [constituent.uri]) }
  let!(:document)                 { create(:exhibition, documents: [asset.uri]) }
  let!(:representation)           { create(:exhibition, representations: [asset.uri]) }
  let!(:preferred_representation) { create(:exhibition, preferred_representation: asset.uri) }

  context "with an asset containing all the types of relationships" do
    let(:relationships) { described_class.new(asset) }
    it "maps all incoming relationships to the asset" do
      expect(relationships.documents).to contain_exactly(kind_of(SolrDocument))
      expect(relationships.document_ids).to eq([document.id])
      expect(relationships.representations).to contain_exactly(kind_of(SolrDocument))
      expect(relationships.representation_ids).to eq([representation.id])
      expect(relationships.preferred_representations).to contain_exactly(kind_of(SolrDocument))
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

  context "with an attachment" do
    subject { described_class.new(attachment) }
    specify { expect(subject.assets.map(&:id)).to contain_exactly(asset.id) }
  end

  context "with a constituent" do
    subject { described_class.new(constituent) }
    specify { expect(subject.constituents.map(&:id)).to contain_exactly(asset.id) }
  end
end
