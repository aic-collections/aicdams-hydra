# frozen_string_literal: true
require 'rails_helper'

describe AgentPresenter do
  let(:resource)        { build(:agent, id: '1234') }
  let(:ability)         { Ability.new(nil) }
  let(:solr_doc)        { SolrDocument.new(resource.to_solr) }
  let(:presenter)       { described_class.new(solr_doc, ability) }
  let(:asset_presenter) { double }

  subject { presenter }

  it_behaves_like "a citi presenter"
  it_behaves_like "a citi presenter with related assets"
end
