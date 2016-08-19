# frozen_string_literal: true
require 'rails_helper'

describe 'curation_concerns/base/_relationships.html.erb' do
  let(:asset)           { build(:asset, id: '1234') }
  let(:asset_doc)       { SolrDocument.new(asset.to_solr) }
  let(:solr_document)   { SolrDocument.new(citi_resource.to_solr) }
  let(:asset_presenter) { AssetPresenter.new(asset_doc, ability) }
  let(:ability)         { double }
  let(:page)            { Capybara::Node::Simple.new(rendered) }

  subject { page }

  describe "an exhibition" do
    let(:citi_resource)  { build(:exhibition, id: '999') }
    let(:citi_presenter) { ExhibitionPresenter.new(solr_document, ability) }

    context "with no relationships" do
      before { render 'curation_concerns/base/relationships.html.erb', presenter: citi_presenter }
      specify do
        is_expected.to have_content("No relationships found for this Exhibition")
        is_expected.to have_link("Add Representations", href: "/batch_uploads/new?representation_for=999")
        is_expected.to have_link("Add Documentation", href: "/batch_uploads/new?document_for=999")
      end
    end

    context "with representations" do
      before do
        allow(view).to receive(:render_thumbnail_tag)
        allow(citi_presenter).to receive(:representation_presenters).and_return([asset_presenter])
        render 'curation_concerns/base/relationships.html.erb', presenter: citi_presenter
      end
      it { is_expected.to have_content("Representations") }
    end

    context "with documents" do
      before do
        allow(view).to receive(:render_thumbnail_tag)
        allow(citi_presenter).to receive(:document_presenters).and_return([asset_presenter])
        render 'curation_concerns/base/relationships.html.erb', presenter: citi_presenter
      end
      it { is_expected.to have_content("Documentation") }
    end

    context "with preferred representations" do
      before do
        allow(view).to receive(:render_thumbnail_tag)
        allow(citi_presenter).to receive(:preferred_representation_presenters).and_return([asset_presenter])
        render 'curation_concerns/base/relationships.html.erb', presenter: citi_presenter
      end
      it { is_expected.to have_content("Preferred Representation") }
    end
  end

  describe "an asset" do
    let(:citi_resource)  { build(:exhibition, id: '999') }
    let(:citi_presenter) { CitiResourcePresenter.new(solr_document, ability) }

    context "with no relationships" do
      before { render 'curation_concerns/base/relationships.html.erb', presenter: asset_presenter }
      it { is_expected.to have_content("No relationships found for this Asset") }
    end

    context "when related as a representation" do
      before do
        allow(asset_presenter).to receive(:has_relationships?).and_return(true)
        allow(asset_presenter).to receive(:representation_presenters).and_return([citi_presenter])
        render 'curation_concerns/base/relationships.html.erb', presenter: asset_presenter
      end
      it { is_expected.to have_content("Relationships") }
    end

    context "when related as a document" do
      before do
        allow(asset_presenter).to receive(:has_relationships?).and_return(true)
        allow(asset_presenter).to receive(:document_presenters).and_return([citi_presenter])
        render 'curation_concerns/base/relationships.html.erb', presenter: asset_presenter
      end
      it { is_expected.to have_content("Documentation") }
    end

    context "when related as a preferred representation" do
      before do
        allow(asset_presenter).to receive(:has_relationships?).and_return(true)
        allow(asset_presenter).to receive(:preferred_representation_presenters).and_return([citi_presenter])
        render 'curation_concerns/base/relationships.html.erb', presenter: asset_presenter
      end
      it { is_expected.to have_content("Preferred Representation") }
    end
  end
end
