# frozen_string_literal: true
require 'rails_helper'

describe CitiResource do
  describe "RDF type" do
    subject { described_class.new.type }
    it { is_expected.to contain_exactly(AICType.Resource, AICType.CitiResource) }
  end

  describe "terms" do
    CitiResourceTerms.all.each do |term|
      it { is_expected.to respond_to(term) }
    end
  end

  describe "#citi_uid" do
    subject { described_class.properties["citi_uid"] }
    it { is_expected.not_to be_multiple }
  end

  describe "#status" do
    subject { described_class.new.status }
    it { is_expected.to eq(StatusType.active) }
  end

  describe "::find_by_citi_uid" do
    let!(:resource) { described_class.create(citi_uid: "AB-1234") }
    subject { described_class.find_by_citi_uid(id) }
    context "with an exact search" do
      let(:id) { "AB-1234" }
      its(:citi_uid) { is_expected.to eq(id) }
    end
    context "with a fuzzy search" do
      let(:id) { "AB-1" }
      it { is_expected.to be_nil }
    end
    context "with a nil id" do
      let(:id) { nil }
      it { is_expected.to be_nil }
    end
  end

  describe "with events" do
    subject { described_class.new }
    its(:events) { is_expected.to be_empty }
  end
end
