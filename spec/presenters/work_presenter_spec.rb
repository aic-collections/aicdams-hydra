# frozen_string_literal: true
require 'rails_helper'

describe WorkPresenter do
  let(:resource)        { build(:work, id: '1234', uid: '1234', pref_label: 'Fine Art') }
  let(:ability)         { Ability.new(nil) }
  let(:solr_doc)        { SolrDocument.new(resource.to_solr) }
  let(:presenter)       { described_class.new(solr_doc, ability) }
  let(:asset_presenter) { double }

  subject { presenter }

  it_behaves_like "a citi presenter"
  it_behaves_like "a citi presenter with related assets"

  describe "#artist_presenters?" do
    it { is_expected.to be_artist_presenters }
  end

  describe "#current_location_presenters?" do
    it { is_expected.to be_current_location_presenters }
  end

  it "will return a formatted preferred_label and uid" do
    expect(presenter.display_pref_label_and_uid).to eq("Fine Art (1234)")
  end
end
