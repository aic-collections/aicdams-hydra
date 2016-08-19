# frozen_string_literal: true
require 'rails_helper'

describe Exhibition do
  describe "RDF type" do
    subject { described_class.new.type }
    it { is_expected.to include(AICType.Exhibition) }
  end

  describe "terms" do
    subject { described_class.new }
    ExhibitionPresenter.terms.each do |term|
      it { is_expected.to respond_to(term) }
    end
  end

  describe "cardinality" do
    [:start_date, :end_date, :name_official, :name_working, :exhibition_type].each do |term|
      it "limits #{term} to a single value" do
        expect(described_class.properties[term.to_s].multiple?).to be false
      end
    end
  end

  describe "#pref_label" do
    subject { exhibition.pref_label }
    context "by default" do
      let(:exhibition) { build(:exhibition, name_working: "working name", name_official: nil) }
      it { is_expected.to eq(exhibition.name_working) }
    end
    context "with an official name" do
      let(:exhibition) { build(:exhibition, name_official: "official name", name_working: "working name") }
      it { is_expected.to eq(exhibition.name_official) }
    end
  end

  it_behaves_like "a model for a Citi resource"
  it_behaves_like "an unfeatureable model"
end
