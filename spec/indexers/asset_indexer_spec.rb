# frozen_string_literal: true
require 'rails_helper'

describe AssetIndexer do
  describe "#generate_solr_document" do
    let(:asset)    { create(:asset, :with_metadata) }
    let(:solr_doc) { described_class.new(asset).generate_solr_document }

    it "indexes the correct fields" do
      expect(solr_doc["digitization_source_tesim"]).to eq(asset.digitization_source.pref_label)
      expect(solr_doc["compositing_tesim"]).to eq(asset.compositing.pref_label)
      expect(solr_doc["light_type_tesim"]).to eq(asset.light_type.pref_label)
      expect(solr_doc["light_type_tesim"]).to eq(asset.light_type.pref_label)
      expect(solr_doc["status_tesim"]).to eq(asset.status.pref_label)
      expect(solr_doc["aic_depositor_ssim"]).to eq(asset.aic_depositor.nick)
      expect(solr_doc["dept_created_tesim"]).to eq(asset.dept_created.pref_label)
    end

    context "with all three document types" do
      it "builds a facet list with three types" do
        expect(solr_doc["aic_type_sim"]).to contain_exactly("Asset", "Still Image", "Event Photography", "Imaging", "Lecture")
      end
      it "builds a display field with three types" do
        expect(solr_doc["document_types_tesim"]).to eq("Imaging > Event Photography > Lecture")
      end
    end

    context "with one document type" do
      let(:asset) { build(:asset, document_type: AICDocType.AdMaterial) }
      it "builds a facet list with one type" do
        expect(solr_doc["aic_type_sim"]).to contain_exactly("Asset", "Still Image", "Ad Material")
      end
      it "builds a display field with one type" do
        expect(solr_doc["document_types_tesim"]).to eq("Ad Material")
      end
    end

    context "with two document types" do
      let(:asset) { build(:asset, document_type: AICDocType.AdMaterial, first_document_sub_type: AICDocType.MembershipEvent) }
      it "builds a facet list with two types" do
        expect(solr_doc["aic_type_sim"]).to contain_exactly("Asset", "Still Image", "Ad Material", "Membership event")
      end
      it "builds a display field with two types" do
        expect(solr_doc["document_types_tesim"]).to eq("Ad Material > Membership event")
      end
    end
  end
end
