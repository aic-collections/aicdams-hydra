# frozen_string_literal: true
require 'rails_helper'

describe 'curation_concerns/base/_add_asset.html.erb' do
  let(:page) { rendered }

  before do
    controller.params = { id: 'asset-id' }
    render
  end

  it "renders links for creating new assets from CITI resources" do
    expect(page).to include("/concern/generic_works/new?representation_for=asset-id")
    expect(page).to include("/concern/generic_works/new?document_for=asset-id")
    expect(page).to include("/batch_uploads/new?representation_for=asset-id")
    expect(page).to include("/batch_uploads/new?document_for=asset-id")
  end
end
