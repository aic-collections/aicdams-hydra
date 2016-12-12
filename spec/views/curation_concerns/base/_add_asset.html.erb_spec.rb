# frozen_string_literal: true
require 'rails_helper'

describe 'curation_concerns/base/_add_asset.html.erb' do
  let(:work)      { build(:work, id: 'work-id', citi_uid: 'work-uid') }
  let(:user)      { create(:user1) }
  let(:presenter) { WorkPresenter.new(SolrDocument.new(work.to_solr), user) }
  let(:page)      { rendered }

  before { render 'curation_concerns/base/add_asset.html.erb', presenter: presenter }

  it "renders links for creating new assets from CITI resources" do
    expect(page).to include("/batch_uploads/new?citi_type=Work&amp;citi_uid%5B%5D=work-uid&amp;relationship=representation_for")
    expect(page).to include("/batch_uploads/new?citi_type=Work&amp;citi_uid%5B%5D=work-uid&amp;relationship=documentation_for")
  end
end
