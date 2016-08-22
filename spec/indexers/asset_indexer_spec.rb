# frozen_string_literal: true
require 'rails_helper'

describe AssetIndexer do
  describe "#generate_solr_document" do
    let(:asset)    { create(:asset, :with_metadata) }
    let(:solr_doc) { described_class.new(asset).generate_solr_document }

    it "indexes the correct fields" do
      expect(solr_doc["document_type_ssim"]).to eq(asset.document_type.pref_label)
      expect(solr_doc["first_document_sub_type_ssim"]).to eq(asset.first_document_sub_type.pref_label)
      expect(solr_doc["second_document_sub_type_ssim"]).to eq(asset.second_document_sub_type.pref_label)
      expect(solr_doc["digitization_source_tesim"]).to eq(asset.digitization_source.pref_label)
      expect(solr_doc["compositing_tesim"]).to eq(asset.compositing.pref_label)
      expect(solr_doc["light_type_tesim"]).to eq(asset.light_type.pref_label)
      expect(solr_doc["light_type_tesim"]).to eq(asset.light_type.pref_label)
      expect(solr_doc["status_tesim"]).to eq(asset.status.pref_label)
      expect(solr_doc["aic_depositor_ssim"]).to eq(asset.aic_depositor.nick)
      expect(solr_doc["dept_created_tesim"]).to eq(asset.dept_created.pref_label)
    end
  end
end
