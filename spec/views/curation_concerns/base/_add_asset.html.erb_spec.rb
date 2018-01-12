# frozen_string_literal: true
require 'rails_helper'

["work", "agent", "exhibition", "shipment", "transaction", "place"].each do |type|
  describe 'curation_concerns/base/_add_asset.html.erb' do
    let(:work)      { build(type.to_sym, id: type + '-id', citi_uid: type + '-uid') }
    let(:user)      { create(:user1) }
    let(:presenter) { (type.capitalize + "Presenter").constantize.new(SolrDocument.new(work.to_solr), user) }
    let(:page)      { rendered }

    before { render 'curation_concerns/base/add_asset.html.erb', presenter: presenter }

    it "renders links for creating new assets from CITI resources" do
      expect(page).to include("/batch_uploads/new?citi_type=#{type.capitalize}&amp;citi_uid%5B%5D=#{type}-uid&amp;relationship=representation_for")
      expect(page).to include("/batch_uploads/new?citi_type=#{type.capitalize}&amp;citi_uid%5B%5D=#{type}-uid&amp;relationship=documentation_for")
    end

    it "has dropdown button that says 'Add New Assets to this CITI #{type.capitalize}'" do
      expect(page).to include("Add New Assets to this CITI #{type.capitalize}")
    end
  end
end
