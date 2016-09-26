# frozen_string_literal: true
require 'rails_helper'

describe Resource do
  describe "RDF type" do
    subject { described_class.new.type.first }
    it { is_expected.to eql(AICType.Resource) }
  end

  describe "terms" do
    subject { described_class.new }
    ResourceTerms.all.each do |term|
      it { is_expected.to respond_to(term) }
    end
  end

  describe "cardinality" do
    [:batch_uid, :citi_icon, :created, :created_by, :preferred_representation, :icon, :status, :uid, :updated, :pref_label].each do |term|
      it "limits #{term} to a single value" do
        expect(described_class.properties[term.to_s].multiple?).to be false
      end
    end
  end

  describe "#created" do
    context "with a bad date" do
      let(:bad_resource) { described_class.create(created: "bad date") }
      subject { ActiveFedora::Base.load_instance_from_solr(bad_resource.id) }
      it do
        pending("Test for bad dates in the solr document?")
        expect(subject.created).to eq("bad date is not a valid date")
      end
    end
  end

  describe "::find_by_label" do
    let!(:resource) { described_class.create(pref_label: "A Foos List") }
    subject { described_class.find_by_label(label) }
    context "with an exact search" do
      let(:label) { "A Foos List" }
      its(:pref_label) { is_expected.to eq(label) }
    end
    context "with a fuzzy search" do
      let(:label) { "Foos List" }
      it { is_expected.to be_nil }
    end
  end

  describe "::accepts_uris_for" do
    subject { described_class.new }
    context "with setters" do
      it { is_expected.to respond_to(:citi_icon_uri=) }
      it { is_expected.to respond_to(:created_by_uri=) }
      it { is_expected.to respond_to(:preferred_representation_uri=) }
      it { is_expected.to respond_to(:icon_uri=) }
      it { is_expected.to respond_to(:contributor_uris=) }
      it { is_expected.to respond_to(:document_uris=) }
      it { is_expected.to respond_to(:representation_uris=) }
      it { is_expected.to respond_to(:publisher_uris=) }
      it { is_expected.to respond_to(:rights_statement_uris=) }
      it { is_expected.to respond_to(:rights_holder_uris=) }
    end

    context "with getters" do
      it { is_expected.to respond_to(:citi_icon_uri) }
      it { is_expected.to respond_to(:created_by_uri) }
      it { is_expected.to respond_to(:preferred_representation_uri) }
      it { is_expected.to respond_to(:icon_uri) }
      it { is_expected.to respond_to(:contributor_uris) }
      it { is_expected.to respond_to(:document_uris) }
      it { is_expected.to respond_to(:representation_uris) }
      it { is_expected.to respond_to(:publisher_uris) }
      it { is_expected.to respond_to(:rights_statement_uris) }
      it { is_expected.to respond_to(:rights_holder_uris) }
    end
  end
end
