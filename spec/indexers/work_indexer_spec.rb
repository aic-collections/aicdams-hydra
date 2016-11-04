# frozen_string_literal: true
require 'rails_helper'

describe WorkIndexer do
  describe "#generate_solr_document" do
    let(:solr_doc) { described_class.new(work).generate_solr_document }

    context "with a basic work" do
      let(:agent)       { build(:agent, :with_sample_metadata) }
      let(:place)       { build(:place, :with_sample_metadata) }
      let(:work)       { build(:work, :with_sample_metadata) }

      let(:department) { build(:department, pref_label: "Department of Works") }
      before {
        allow(work).to receive(:department).and_return([department])
        allow(work).to receive(:artist).and_return([agent])
        allow(work).to receive(:current_location).and_return([place])
      }

      it "indexes the correct fields" do
        expect(solr_doc["aic_type_sim"]).to eq("Work")
        expect(solr_doc["resource_type_tesim"]).to eq("Work")
        expect(solr_doc["relationships_isim"]).to eq(0)
        expect(solr_doc["department_tesim"]).to contain_exactly("Department of Works")
        expect(solr_doc["artist_tesim"]).to eq(["Pablo Picasso (1881-1973)"])
        expect(solr_doc["current_location_tesim"]).to eq(["Sample Place"])
      end
    end
  end
end
