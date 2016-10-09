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
end
