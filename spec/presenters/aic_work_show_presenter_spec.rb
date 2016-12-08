# frozen_string_literal: true
require 'rails_helper'

RSpec.describe AICWorkShowPresenter do
  let(:asset) { build(:department_asset, id: "1234", pref_label: "Sample Label") }
  let(:solr_document) { SolrDocument.new(asset.to_solr) }
  let(:request) { double(base_url: 'http://test.host') }
  let(:ability) { nil }
  let(:presenter) { described_class.new(solr_document, ability, request) }

  describe "#manifest_url" do
    subject { presenter.manifest_url }
    it { is_expected.to eq 'http://test.host/concern/generic_works/1234/manifest' }
  end
end
