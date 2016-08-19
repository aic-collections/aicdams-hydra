# frozen_string_literal: true
require 'rails_helper'

describe CitiResourcePresenter do
  let(:resource)        { build(:exhibition, id: '1234') }
  let(:ability)         { Ability.new(nil) }
  let(:solr_doc)        { SolrDocument.new(resource.to_solr) }
  let(:presenter)       { described_class.new(solr_doc, ability) }
  let(:asset_presenter) { double }

  subject { presenter }

  it_behaves_like "a citi presenter"
end
