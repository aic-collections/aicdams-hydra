# frozen_string_literal: true
require 'rails_helper'

describe Place do
  describe "RDF type" do
    subject { described_class.new.type }
    it { is_expected.to include(AICType.Place) }
  end

  describe "terms" do
    subject { described_class.new }
    PlacePresenter.terms.each do |term|
      it { is_expected.to respond_to(term) }
    end
  end

  describe "cardinality" do
    [:lat, :long].each do |term|
      it "limits #{term} to a single value" do
        expect(described_class.properties[term.to_s].multiple?).to be false
      end
    end
  end

  it_behaves_like "a model for a Citi resource"
  it_behaves_like "an unfeatureable model"
end
