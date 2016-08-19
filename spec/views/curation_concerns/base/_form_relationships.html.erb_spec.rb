# frozen_string_literal: true
require 'rails_helper'

describe 'curation_concerns/base/_form_relationships.html.erb' do
  let(:user)    { create(:user1) }
  let(:work)    { create(:department_asset) }
  let(:ability) { double }
  let(:form)    { CurationConcerns::GenericWorkForm.new(work, ability) }

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
    before { controller.params = { representation_for: 'rep-id' } }
    it "place its id in a hidden field" do
      expect(page).to have_selector('#generic_work_additional_representation', visible: 'false')
      expect(page).to have_selector('p', text: 'CITI resource rep-id will be added as a representation')
    end
  end

  context "when passing a document in the url" do
    before { controller.params = { document_for: 'doc-id' } }
    it "place its id in a hidden field" do
      expect(page).to have_selector('#generic_work_additional_document', visible: 'false')
      expect(page).to have_selector('p', text: 'CITI resource doc-id will be added as a document')
    end
  end
end
