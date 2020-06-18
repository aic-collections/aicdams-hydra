# frozen_string_literal: true
require 'rails_helper'

describe AssetIndexer do
  describe "#generate_solr_document" do
    let(:attachment)  { create(:asset) }
    let(:constituent) { create(:asset) }
    let(:asset)       { create(:department_asset, :with_metadata,
                               attachments: [attachment.uri],
                               constituent_of: [constituent.uri]) }
    let(:solr_doc)    { described_class.new(asset).generate_solr_document }

    it "indexes the correct fields" do
      expect(solr_doc["digitization_source_tesim"]).to eq(asset.digitization_source.pref_label)
      expect(solr_doc["compositing_tesim"]).to eq(asset.compositing.pref_label)
      expect(solr_doc["light_type_tesim"]).to eq(asset.light_type.pref_label)
      expect(solr_doc["light_type_tesim"]).to eq(asset.light_type.pref_label)
      expect(solr_doc["status_tesim"]).to eq(asset.status.pref_label)
      expect(solr_doc["aic_depositor_ssim"]).to eq(asset.aic_depositor.nick)
      expect(solr_doc["dept_created_tesim"]).to eq(asset.dept_created.pref_label)
      expect(solr_doc["aic_type_sim"]).to contain_exactly("Asset", "Still Image")
      expect(solr_doc["dept_created_sim"]).to eq(asset.dept_created.pref_label)
      expect(solr_doc["dept_created_citi_uid_ssim"]).to eq(asset.dept_created.citi_uid)
      expect(solr_doc["attachments_ssim"]).to contain_exactly(attachment.id)
      expect(solr_doc["constituent_of_ssim"]).to contain_exactly(constituent.id)
      expect(solr_doc["depositor_full_name_tesim"]).to contain_exactly("First User")
      expect(solr_doc["created_dtsi"]).to eq("2016-10-30T00:00:00Z")
      expect(solr_doc["updated_dtsi"]).to eq("2016-10-31T00:00:00Z")
      expect(solr_doc["public_domain_bsi"]).to be(false)
      expect(solr_doc["publishable_bsi"]).to be(false)
    end

    context "with all three document types" do
      it "builds a facet list with three types" do
        expect(solr_doc["document_types_sim"]).to contain_exactly("Event Photography", "Imaging", "Lecture")
      end
      it "builds a display field with three types" do
        expect(solr_doc["document_types_tesim"]).to eq("Imaging > Event Photography > Lecture")
      end
    end

    context "with one document type" do
      let(:asset) { build(:asset, document_type: AICDocType.AdMaterial) }
      it "builds a facet list with one type" do
        expect(solr_doc["document_types_sim"]).to contain_exactly("Ad Material")
      end
      it "builds a display field with one type" do
        expect(solr_doc["document_types_tesim"]).to eq("Ad Material")
      end
    end

    context "with two document types" do
      let(:asset) { build(:asset, document_type: AICDocType.AdMaterial, first_document_sub_type: AICDocType.MembershipEvent) }
      it "builds a facet list with two types" do
        expect(solr_doc["document_types_sim"]).to contain_exactly("Ad Material", "Membership event")
      end
      it "builds a display field with two types" do
        expect(solr_doc["document_types_tesim"]).to eq("Ad Material > Membership event")
      end
    end

    context "with no relationships" do
      let(:asset) { create(:asset, :with_metadata) }
      let(:solr_doc) { described_class.new(asset).generate_solr_document }
      it "creates a facet for assets without relationships" do
        expect(solr_doc["representation_sim"]).to eq("No Relationship")
      end
    end

    context 'with no file sets' do
      before { allow(asset).to receive(:members).and_return([]) }

      specify do
        expect(solr_doc["member_ids_ssim"]).to be_empty
        expect(solr_doc["intermediate_ids_ssim"]).to be_empty
        expect(solr_doc["original_ids_ssim"]).to be_empty
        expect(solr_doc["preservation_ids_ssim"]).to be_empty
        expect(solr_doc["legacy_ids_ssim"]).to be_empty
      end
    end

    context 'with an intermediate file set' do
      let(:indexer)  { described_class.new(asset) }
      let(:member) { instance_double(AssetIndexer::Member, id: "intermediate", type: [AICType.IntermediateFileSet]) }
      let(:fs) { instance_double(FileSet, file_size: "1234") }

      before { allow(indexer).to receive(:cached_members).and_return([member]) }
      before { allow(asset).to receive(:intermediate_file_set).and_return([fs]) }

      specify do
        solr_doc = indexer.generate_solr_document
        expect(solr_doc["member_ids_ssim"]).to be_empty
        expect(solr_doc["intermediate_ids_ssim"]).to contain_exactly("intermediate")
        expect(solr_doc["original_ids_ssim"]).to be_empty
        expect(solr_doc["preservation_ids_ssim"]).to be_empty
        expect(solr_doc["legacy_ids_ssim"]).to be_empty
        expect(solr_doc[Solrizer.solr_name("file_size", :stored_sortable, type: :long)]).to eq "1234"
      end
    end

    context 'with an original file set' do
      let(:indexer)  { described_class.new(asset) }
      let(:member) { instance_double(AssetIndexer::Member, id: "original", type: [AICType.OriginalFileSet]) }

      before { allow(indexer).to receive(:cached_members).and_return([member]) }
      before { allow(asset).to receive(:intermediate_file_set).and_return([]) }

      specify do
        solr_doc = indexer.generate_solr_document
        expect(solr_doc["member_ids_ssim"]).to be_empty
        expect(solr_doc["intermediate_ids_ssim"]).to be_empty
        expect(solr_doc["original_ids_ssim"]).to contain_exactly("original")
        expect(solr_doc["preservation_ids_ssim"]).to be_empty
        expect(solr_doc["legacy_ids_ssim"]).to be_empty
        expect(solr_doc[Solrizer.solr_name("file_size", :stored_sortable, type: :long)]).to be_nil
      end
    end

    context 'with a preservation file set' do
      let(:indexer)  { described_class.new(asset) }
      let(:member) { instance_double(AssetIndexer::Member, id: "preservation", type: [AICType.PreservationMasterFileSet]) }

      before { allow(indexer).to receive(:cached_members).and_return([member]) }

      specify do
        solr_doc = indexer.generate_solr_document
        expect(solr_doc["member_ids_ssim"]).to be_empty
        expect(solr_doc["intermediate_ids_ssim"]).to be_empty
        expect(solr_doc["original_ids_ssim"]).to be_empty
        expect(solr_doc["preservation_ids_ssim"]).to contain_exactly("preservation")
        expect(solr_doc["legacy_ids_ssim"]).to be_empty
      end
    end

    context 'with a legacy file set' do
      let(:indexer)  { described_class.new(asset) }
      let(:member) { instance_double(AssetIndexer::Member, id: "legacy", type: [AICType.LegacyFileSet]) }

      before { allow(indexer).to receive(:cached_members).and_return([member]) }

      specify do
        solr_doc = indexer.generate_solr_document
        expect(solr_doc["member_ids_ssim"]).to be_empty
        expect(solr_doc["intermediate_ids_ssim"]).to be_empty
        expect(solr_doc["original_ids_ssim"]).to be_empty
        expect(solr_doc["preservation_ids_ssim"]).to be_empty
        expect(solr_doc["legacy_ids_ssim"]).to contain_exactly("legacy")
      end
    end
  end
end
