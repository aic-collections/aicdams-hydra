# frozen_string_literal: true
require 'rails_helper'

describe "sufia/homepage/_recent_document.html.erb" do
  let(:asset)     { build(:asset, id: 'asset-id', pref_label: "Foo") }
  let(:document)  { SolrDocument.new(asset.to_solr) }

  before { allow(view).to receive(:render_thumbnail_tag) }

  subject { Capybara::Node::Simple.new(rendered) }

  context "when the user has read rights to the asset" do
    let(:user) { create(:user1) }
    before { render "sufia/homepage/recent_document.html.erb", recent_document: document, current_user: user }
    it { is_expected.to have_link("Foo") }
  end

  context "when the user does not have read rights to the asset" do
    let(:user) { create(:user2) }
    before { render "sufia/homepage/recent_document.html.erb", recent_document: document, current_user: user }
    it { is_expected.not_to have_link("Foo") }
  end
end
