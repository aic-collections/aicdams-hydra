# frozen_string_literal: true

require 'rails_helper'

describe UnauthorizedPresenter do
  context "with a GenericWork" do
    subject { presenter }
    let(:resource) { create(:department_asset, pref_label: "Sample Label") }
    let(:solr_document) { SolrDocument.new(resource.to_solr) }
    let(:presenter)     { described_class.new(resource.id, "GenericWork") }
    before do
      allow(GenericWork).to receive(:find).with(resource.id).and_return(resource)
    end

    it "will get minimum info from the requested asset" do
      expect(subject.title_or_label).to eq("Sample Label")
      expect(subject.id).to eq(resource.id)
      expect(subject.depositor_full_name).to eq("First User")
      expect(subject.depositor_first_name).to eq("First")
      expect(subject.thumbnail_path).to eq("/assets/work-ff055336041c3f7d310ad69109eda4a887b16ec501f35afc0a547c4adb97ee72.png")
    end
  end

  context "works with a Place" do
    subject { presenter }
    let(:location) { create(:place, pref_label: "Sample Place") }
    let(:solr_document) { SolrDocument.new(location.to_solr) }
    let(:presenter) { described_class.new(location.id, "Place") }
    before do
      allow(Place).to receive(:find).with(location.id).and_return(location)
    end

    it "can find the resource" do
      expect(subject.title_or_label).to eq("Sample Place")
    end
  end

  context "works with an Agent" do
    subject { presenter }
    let(:agent) { create(:agent, pref_label: "Sample Agent") }
    let(:solr_document) { SolrDocument.new(agent.to_solr) }
    let(:presenter) { described_class.new(agent.id, "Agent") }
    before do
      allow(Agent).to receive(:find).with(agent.id).and_return(agent)
    end

    it "can find the resource" do
      expect(subject.title_or_label).to eq("Sample Agent")
    end
  end
end
