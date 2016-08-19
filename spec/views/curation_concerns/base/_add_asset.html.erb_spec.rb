# frozen_string_literal: true
require 'rails_helper'

describe 'curation_concerns/base/_add_asset.html.erb' do
  let(:asset)     { build(:asset, id: 'asset-id') }
  let(:user)      { create(:user1) }
  let(:presenter) { AssetPresenter.new(SolrDocument.new(asset.to_solr), user) }
  let(:page)      { rendered }

  before { render 'curation_concerns/base/add_asset.html.erb', presenter: presenter }

  it "renders links for creating new assets from CITI resources" do
    expect(page).not_to include("/concern/generic_works/new?representation_for=asset-id")
    expect(page).not_to include("/concern/generic_works/new?document_for=asset-id")
    expect(page).to include("/batch_uploads/new?representation_for=asset-id")
    expect(page).to include("/batch_uploads/new?document_for=asset-id")
  end
end
