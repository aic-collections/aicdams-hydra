# frozen_string_literal: true
require 'rails_helper'

describe ShipmentPresenter do
  let(:resource)        { build(:shipment, id: '1234', pref_label: '1234', uid: '1234') }
  let(:ability)         { Ability.new(nil) }
  let(:solr_doc)        { SolrDocument.new(resource.to_solr) }
  let(:presenter)       { described_class.new(solr_doc, ability) }
  let(:asset_presenter) { double }

  subject { presenter }

  it_behaves_like "a citi presenter"
  it_behaves_like "a citi presenter with related assets"

  it "will return a formatted preferred_label" do
    expect(presenter.display_pref_label_and_uid).to eq("1234")
  end
end
