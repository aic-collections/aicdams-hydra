# frozen_string_literal: true
require 'rails_helper'

describe Work do
  describe "intial RDF types" do
    subject { described_class.new.type }
    it { is_expected.to include(AICType.Work,
                                AICType.Resource,
                                AICType.CitiResource,
                                Hydra::PCDM::Vocab::PCDMTerms.Object,
                                Hydra::Works::Vocab::WorksTerms.Work) }
  end

  describe "metadata" do
    subject { described_class.new }
    context "defined in the presenter" do
      WorkPresenter.terms.each do |term|
        it { is_expected.to respond_to(term) }
      end
    end
  end

  describe "cardinality" do
    (WorkPresenter.model_terms - [:artist, :department, :current_location, :dimensions_display]).each do |term|
      it "limits #{term} to a single value" do
        expect(described_class.properties[term.to_s].multiple?).to be false
      end
    end
  end

  describe "#artist" do
    let(:agent) { create(:agent) }
    subject     { described_class.new }
    before      { subject.artist_uris = [agent.uri] }

    its(:artist)   { is_expected.to contain_exactly(agent) }
    its(:to_solr)  { is_expected.to include(Solrizer.solr_name("artist", :stored_searchable) => [agent.pref_label]) }
    after { agent.destroy }
  end

  describe "#department" do
    let(:department) { create(:department100) }
    subject     { described_class.new }
    before      { subject.department_uris = [department.uri] }

    its(:department) { is_expected.to contain_exactly(department) }
    its(:to_solr) { is_expected.to include(Solrizer.solr_name("department", :stored_searchable) => [department.pref_label]) }
    after { department.destroy }
  end

  describe "#current_location" do
    let(:place) { create(:place) }
    subject     { described_class.new }
    before      { subject.current_location_uris = [place.uri] }

    its(:current_location) { is_expected.to contain_exactly(place) }
    its(:to_solr) { is_expected.to include(Solrizer.solr_name("current_location", :stored_searchable) => [place.pref_label]) }
    after { place.destroy }
  end
end
