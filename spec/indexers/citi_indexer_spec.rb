# frozen_string_literal: true
require 'rails_helper'

describe CitiIndexer do
  describe "#generate_solr_document" do
    let(:solr_doc) { described_class.new(work).generate_solr_document }

    context "with a basic work" do
      let(:work) { build(:work, :with_sample_metadata) }

      it "indexes the correct fields" do
        expect(solr_doc["aic_type_sim"]).to eq("Work")
        expect(solr_doc["resource_type_tesim"]).to eq("Work")
        expect(solr_doc["relationships_isim"]).to eq(0)
      end
    end

    context "with relationships" do
      let!(:asset) { create(:asset) }
      let!(:work)  { create(:work, representations: [asset]) }

      it "indexes the correct number of relationships" do
        expect(solr_doc["relationships_isim"]).to eq(1)
      end
    end
  end
end
