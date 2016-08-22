# frozen_string_literal: true
require 'rails_helper'

describe 'curation_concerns/agents/_form.html.erb' do
  let(:user)    { create(:user1) }
  let(:ability) { double }
  let(:form)    { CurationConcerns::AgentForm.new(resource, ability) }
  let(:page)    { Capybara::Node::Simple.new(rendered) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
    assign(:form, form)
  end

  context "when editing without existing representations" do
    let(:resource) { build(:agent) }
    before { render }
    it "renders fields for representations" do
      expect(page).to have_selector('input#agent_document_uris')
      expect(page).to have_selector('input#agent_representation_uris')
      expect(page).to have_selector('input#agent_preferred_representation_uri')
    end
  end

  context "when editing with existing representations" do
    let(:asset) { build(:asset) }
    let(:resource) do
      build(:agent, documents: [asset], representations: [asset], preferred_representation: asset)
    end

    before { render }

    it "displays the existing uris" do
      within("div.agent_document_uris") do
        expect(page).to have_selector("input[value='#{asset.uri}']")
      end
      within("div.agent_representation_uris") do
        expect(page).to have_selector("input[value='#{asset.uri}']")
      end
      within("div.agent_preferred_representation_uri") do
        expect(page).to have_selector("input[value='#{asset.uri}']")
      end
    end
  end
end
