# frozen_string_literal: true
require 'rails_helper'

describe GenericWork do
  let(:user)         { create(:user1) }
  let(:example_file) { create(:asset) }

  subject { described_class.new }

  describe "::human_readable_type" do
    subject { described_class.human_readable_type }
    it { is_expected.to eq("Asset") }
  end

  context "without setting a type" do
    subject { build(:asset_without_type) }
    it "raises and error" do
      expect(-> { subject.save }).to raise_error(ArgumentError, "Can't assign a prefix without a type")
    end
  end

  describe "intial RDF types" do
    subject { described_class.new.type }
    it { is_expected.to include(AICType.Asset, AICType.Resource) }
  end

  describe "asserting StillImage" do
    subject { build(:asset) }
    specify { expect(subject.type).to include(AICType.Asset, AICType.StillImage) }
    let(:hash) { Digest::MD5.hexdigest(subject.uid) }
    let(:dhash) { [hash[0, 8], hash[8, 4], hash[12, 4], hash[16, 4], hash[20..-1]].join('-') }
    context "and re-asserting StillImage" do
      before  { subject.assert_still_image }
      specify { expect(subject).not_to receive(:set_value) }
    end
    context "and asserting Text" do
      specify { expect(subject.assert_text).to be false }
    end
    describe "#to_solr" do
      let(:keyword) { create(:list_item) }

      before { subject.keyword = [keyword.uri] }

      it "contains our custom solr fields" do
        expect(subject.to_solr[Solrizer.solr_name("aic_type", :facetable)]).to include("Asset", "Still Image")
        expect(subject.to_solr[Solrizer.solr_name("keyword", :facetable)]).to contain_exactly(keyword.pref_label)
        expect(subject.to_solr[Solrizer.solr_name("keyword", :stored_searchable)]).to contain_exactly(keyword.pref_label)
      end
    end
    describe "minting uids" do
      before { subject.save }
      it "uses a checksum as a path" do
        expect(subject.id).to match(/^\h{8}-\h{4}-\h{4}-\h{4}-\h{12}/)
        expect(subject.id).to eql(dhash)
      end
    end
  end

  describe "setting type to Text" do
    subject { build(:text_asset) }
    specify { expect(subject.type).to include(AICType.Asset, AICType.Text) }
    let(:hash) { Digest::MD5.hexdigest(subject.uid) }
    let(:dhash) { [hash[0, 8], hash[8, 4], hash[12, 4], hash[16, 4], hash[20..-1]].join('-') }
    context "and re-asserting Text" do
      before  { subject.assert_text }
      specify { expect(subject).not_to receive(:set_value) }
    end
    context "and asserting StillImage" do
      specify { expect(subject.assert_still_image).to be false }
    end
    describe "#to_solr" do
      specify { expect(subject.to_solr[Solrizer.solr_name("aic_type", :facetable)]).to include("Asset", "Text") }
    end
    describe "minting uids" do
      before { subject.save }
      it "uses a checksum as a path" do
        expect(subject.id).to match(/^\h{8}-\h{4}-\h{4}-\h{4}-\h{12}/)
        expect(subject.id).to eql(dhash)
      end
    end
  end

  describe "metadata" do
    context "defined in the presenter" do
      AssetPresenter.terms.each do |term|
        it { is_expected.to respond_to(term) }
      end
    end
  end

  describe "cardinality" do
    [:capture_device, :dept_created, :digitization_source, :compositing, :light_type, :transcript].each do |term|
      it "limits #{term} to a single value" do
        expect(described_class.properties[term.to_s].multiple?).to be false
      end
    end
  end

  describe "#destroy" do
    it "deletes the resource" do
      expect(example_file.destroy).to be_kind_of(described_class)
    end
  end

  describe "#uid" do
    context "when changed" do
      subject do
        example_file.uid = "1234"
        example_file.save
        example_file.errors
      end
      its(:full_messages) { is_expected.to include("Uid must match checksum") }
    end
  end

  describe "#title" do
    let(:work) { described_class.new }
    subject { work.title.first }
    context "without a pref_label" do
      it { is_expected.to be_nil }
    end
    context "without a pref_label" do
      let(:work) { described_class.create(pref_label: "A Label") }
      it { is_expected.to eq("A Label") }
    end
  end

  describe "::accepts_uris_for" do
    let(:work) { build(:asset) }
    let(:item) { create(:list_item) }
    context "using a multi-valued term" do
      subject { work }
      context "with a string" do
        before { work.keyword_uris = [item.uri.to_s] }
        its(:keyword) { is_expected.to contain_exactly(item) }
        its(:keyword_uris) { is_expected.to contain_exactly(item.uri.to_s) }
      end
      context "with a RDF::URI" do
        before { work.keyword_uris = [item.uri] }
        its(:keyword) { is_expected.to contain_exactly(item) }
        its(:keyword_uris) { is_expected.to contain_exactly(item.uri.to_s) }
      end
      context "with a singular value" do
        it "raises an ArgumentError" do
          expect { work.keyword_uris = item.uri }.to raise_error(ArgumentError)
        end
      end
      context "with empty strings" do
        before { work.keyword_uris = [""] }
        its(:keyword) { is_expected.to be_empty }
        its(:keyword_uris) { is_expected.to be_empty }
      end
      context "with empty arrays" do
        before { work.keyword_uris = [] }
        its(:keyword) { is_expected.to be_empty }
        its(:keyword_uris) { is_expected.to be_empty }
      end
      context "with existing values" do
        before { work.keyword_uris = [item.uri.to_s] }
        it "uses a null set to remote them" do
          expect(subject.keyword).not_to be_empty
          work.keyword_uris = []
          expect(subject.keyword).to be_empty
        end
      end
    end
    context "using a single-valued term" do
      subject { work }
      context "with a string" do
        before { work.digitization_source_uri = item.uri.to_s }
        its(:digitization_source) { is_expected.to eq(item) }
        its(:digitization_source_uri) { is_expected.to eq(item.uri.to_s) }
      end
      context "with a RDF::URI" do
        before { work.digitization_source_uri = item.uri }
        its(:digitization_source) { is_expected.to eq(item) }
        its(:digitization_source_uri) { is_expected.to eq(item.uri.to_s) }
      end
      context "with an empty string" do
        before { work.digitization_source_uri = "" }
        its(:digitization_source) { is_expected.to be_nil }
        its(:digitization_source_uri) { is_expected.to be_nil }
      end
      context "with an existing value" do
        before { work.digitization_source_uri = item.uri }
        it "uses nil to remove it" do
          expect { work.digitization_source_uri = nil }.to change { work.digitization_source }.to(nil)
        end
        it "uses an empty string to remove it" do
          expect { work.digitization_source_uri = "" }.to change { work.digitization_source }.to(nil)
        end
      end
    end
    context "with remaining terms" do
      it { is_expected.to respond_to(:document_type_uri=) }
      it { is_expected.to respond_to(:first_document_sub_type_uri=) }
      it { is_expected.to respond_to(:second_document_sub_type_uri=) }
      it { is_expected.to respond_to(:compositing_uri=) }
      it { is_expected.to respond_to(:light_type_uri=) }
      it { is_expected.to respond_to(:view_uris=) }
      it { is_expected.to respond_to(:document_type_uri) }
      it { is_expected.to respond_to(:first_document_sub_type_uri) }
      it { is_expected.to respond_to(:second_document_sub_type_uri) }
      it { is_expected.to respond_to(:compositing_uri) }
      it { is_expected.to respond_to(:light_type_uri) }
      it { is_expected.to respond_to(:view_uris) }
    end
  end
end
