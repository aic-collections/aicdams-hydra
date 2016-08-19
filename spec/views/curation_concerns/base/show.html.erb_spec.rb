# frozen_string_literal: true
require 'rails_helper'

describe 'curation_concerns/base/show.html.erb' do
  let(:solr_document) { SolrDocument.new(asset.to_solr) }
  let(:ability)       { double }

  let(:page)          { Capybara::Node::Simple.new(rendered) }

  before do
    stub_template 'curation_concerns/base/_metadata.html.erb' => ''
    stub_template 'curation_concerns/base/_relationships.html.erb' => ''
    stub_template 'curation_concerns/base/_show_actions.html.erb' => ''
    stub_template 'curation_concerns/base/_representative_media.html.erb' => ''
    stub_template 'curation_concerns/base/_social_media.html.erb' => ''
    stub_template 'curation_concerns/base/_citations.html.erb' => ''
    stub_template 'curation_concerns/base/_items.html.erb' => ''
    assign(:presenter, presenter)
    render
  end

  context "with a department asset" do
    let(:asset)     { build(:department_asset, id: '999', pref_label: 'Department Asset') }
    let(:presenter) { AssetPresenter.new(solr_document, ability) }
    specify do
      expect(page).to have_selector('span.label-warning', text: "Department")
    end
  end

  context "with a registered asset" do
    let(:asset)     { build(:registered_asset, id: '999', pref_label: 'Department Asset') }
    let(:presenter) { AssetPresenter.new(solr_document, ability) }
    specify do
      expect(page).to have_selector('span.label-info', text: "AIC")
    end
  end

  context "with an agent" do
    let(:asset)     { build(:agent, id: '999') }
    let(:presenter) { AgentPresenter.new(solr_document, ability) }
    specify do
      expect(page).to have_selector('span.label-info', text: "AIC")
      expect(page).to have_selector('h1', text: "Sample Agent")
    end
  end

  context "with an exhibition" do
    let(:asset)     { build(:exhibition, id: '999') }
    let(:presenter) { ExhibitionPresenter.new(solr_document, ability) }
    specify do
      expect(page).to have_selector('span.label-info', text: "AIC")
      expect(page).to have_selector('h1', text: "Sample Exhibition")
    end
  end

  context "with a work" do
    let(:asset)     { build(:work, id: '999') }
    let(:presenter) { WorkPresenter.new(solr_document, ability) }
    specify do
      expect(page).to have_selector('span.label-info', text: "AIC")
      expect(page).to have_selector('h1', text: "Sample Work")
    end
  end

  context "with a place" do
    let(:asset)     { build(:place, id: '999') }
    let(:presenter) { PlacePresenter.new(solr_document, ability) }
    specify do
      expect(page).to have_selector('span.label-info', text: "AIC")
      expect(page).to have_selector('h1', text: "Sample Place")
    end
  end

  context "with a shipment" do
    let(:asset)     { build(:shipment, id: '999') }
    let(:presenter) { ShipmentPresenter.new(solr_document, ability) }
    specify do
      expect(page).to have_selector('span.label-info', text: "AIC")
      expect(page).to have_selector('h1', text: "Sample Shipment")
    end
  end

  context "with a transaction" do
    let(:asset)     { build(:transaction, id: '999') }
    let(:presenter) { TransactionPresenter.new(solr_document, ability) }
    specify do
      expect(page).to have_selector('span.label-info', text: "AIC")
      expect(page).to have_selector('h1', text: "Sample Transaction")
    end
  end
end
