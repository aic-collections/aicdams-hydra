# frozen_string_literal: true
require 'rails_helper'

describe 'curation_concerns/base/_form_relationships.html.erb' do
  let(:user)    { create(:user1) }
  let(:asset)   { create(:department_asset) }
  let(:ability) { double }
  let(:form)    { CurationConcerns::GenericWorkForm.new(asset, ability) }

  let(:page) do
    view.simple_form_for form do |f|
      render 'curation_concerns/base/form_relationships.html.erb', f: f
    end
    Capybara::Node::Simple.new(rendered)
  end

  before { allow(controller).to receive(:current_user).and_return(user) }

  context "without passing additional relationships" do
    it "displays fields for adding representations and documents" do
      expect(page).not_to have_selector('#generic_work_additional_representation', visible: 'false')
      expect(page).not_to have_selector('#generic_work_additional_document', visible: 'false')
    end
  end

  context "when passing a representation in the url" do
    before { controller.params = { representation_for: 'rep-id', resource_title: "preferred_label" } }
    it "places its id in a hidden field" do
      expect(page).to have_selector('#generic_work_additional_representation', visible: 'false')
      expect(page).to have_selector('p', text: 'This Asset will be added as a representation of CITI resource preferred_label.')
    end
  end

  context "when passing a document in the url" do
    before { controller.params = { document_for: 'doc-id', resource_title: "preferred_label" } }
    it "places its id in a hidden field" do
      expect(page).to have_selector('#generic_work_additional_document', visible: 'false')
      expect(page).to have_selector('p', text: 'This Asset will be added as documentation of CITI resource preferred_label.')
    end
  end

  context "with existing relationships" do
    let(:work)  { build(:work, id: "1234") }
    let(:agent) { build(:agent, id: "5678") }
    before do
      allow_any_instance_of(HiddenMultiSelectInput).to receive(:render_thumbnail).and_return("thumbnail")
      allow(form).to receive(:documents_for).and_return([work])
      allow(form).to receive(:representations_for).and_return([agent])
    end

    it "renders the form" do
      expect(page).to have_selector("input#generic_work_documents_for", visible: false)
      expect(page).to have_selector("input#generic_work_representations_for", visible: false)
      expect(page.find("input#generic_work_documents_for", visible: false).value).to eq(work.id)
      expect(page.find("input#generic_work_representations_for", visible: false).value).to eq(agent.id)
    end
  end

  context "without existing attachments" do
    it "displays fields for adding attachments" do
      expect(page).to have_selector('table.attachment_uris')
      expect(page).to have_selector('table.attachments_for')
    end
  end

  context "with existing attachments" do
    let(:asset1) { build(:asset, id: '1', pref_label: "First asset", uid: "uid-1") }
    let(:asset2) { build(:asset, id: '2', pref_label: "Second asset") }
    let(:asset1_solr_doc) { SolrDocument.new(asset1.to_solr) }
    let(:asset2_solr_doc) { SolrDocument.new(asset2.to_solr) }

    before do
      allow_any_instance_of(HiddenMultiSelectInput).to receive(:render_thumbnail).and_return("thumbnail")
      allow(asset).to receive(:attachments).and_return([asset1, asset2])
      allow(form).to receive(:attachments_for).and_return([asset1_solr_doc, asset2_solr_doc])
    end

    it "displays the existing uris" do
      expect(page.all("input#generic_work_attachment_uris", visible: false).first.value).to eq(asset1.uri)
      expect(page.all("input#generic_work_attachment_uris", visible: false).last.value).to eq(asset2.uri)
      expect(page.all("input#generic_work_attachments_for", visible: false).first.value).to eq(asset1.id)
      expect(page.all("input#generic_work_attachments_for", visible: false).last.value).to eq(asset2.id)
    end
  end

  context "without existing constituents" do
    it "displays fields for adding constituents" do
      expect(page).to have_selector('table.constituent_of_uris')
      expect(page).to have_selector('table.has_constituent_part')
    end
  end

  context "with existing constituents" do
    let(:asset1) { build(:asset, id: '1', pref_label: "First asset", uid: "uid-1") }
    let(:asset2) { build(:asset, id: '2', pref_label: "Second asset") }
    let(:asset1_solr_doc) { SolrDocument.new(asset1.to_solr) }
    let(:asset2_solr_doc) { SolrDocument.new(asset2.to_solr) }

    before do
      allow_any_instance_of(HiddenMultiSelectInput).to receive(:render_thumbnail).and_return("thumbnail")
      allow(asset).to receive(:constituent_of).and_return([asset1, asset2])
      allow(form).to receive(:has_constituent_part).and_return([asset1_solr_doc, asset2_solr_doc])
    end

    it "displays the existing uris" do
      expect(page.all("input#generic_work_constituent_of_uris", visible: false).first.value).to eq(asset1.uri)
      expect(page.all("input#generic_work_constituent_of_uris", visible: false).last.value).to eq(asset2.uri)
      expect(page.all("input#generic_work_has_constituent_part", visible: false).first.value).to eq(asset1.id)
      expect(page.all("input#generic_work_has_constituent_part", visible: false).last.value).to eq(asset2.id)
    end
  end
end
