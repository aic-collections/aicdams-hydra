# frozen_string_literal: true
require 'rails_helper'

describe "catalog/_thumbnail_list_default.html.erb" do
  let(:asset)     { build(:asset, id: 'asset-id') }
  let(:document)  { SolrDocument.new(asset.to_solr) }

  context "when the current does not have read rights to the asset" do
    let(:user) { create(:user2) }
    it "suppresses links to the asset" do
      expect(view).to receive(:render_thumbnail_tag).with(document, { class: "restricted_resource" }, suppress_link: true)
      render "catalog/thumbnail_list_default.html.erb", document: document, current_user: user
    end
  end

  context "when the current has read rights to the asset" do
    let(:user) { create(:user1) }
    it "suppresses links to the asset" do
      expect(view).to receive(:render_thumbnail_tag).with(document)
      render "catalog/thumbnail_list_default.html.erb", document: document, current_user: user
    end
  end
end
