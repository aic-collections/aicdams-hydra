# frozen_string_literal: true
require 'rails_helper'

describe 'curation_concerns/agents/_form.html.erb' do
  let(:user)     { create(:user1) }
  let(:ability)  { double }
  let(:resource) { build(:agent) }
  let(:form)     { CurationConcerns::AgentForm.new(resource, ability) }
  let(:page)     { Capybara::Node::Simple.new(rendered) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
    assign(:form, form)
  end

  context "when editing without existing representations" do
    before { render }
    it "renders fields for representations" do
      expect(page).to have_selector('table.document_uris')
      expect(page).to have_selector('table.representation_uris')
    end
  end

  context "when editing with existing representations" do
    let(:asset1) { SolrDocument.new(build(:asset, id: '1', pref_label: "First asset", uid: "uid-1").to_solr) }
    let(:asset2) { SolrDocument.new(build(:asset, id: '2', pref_label: "Second asset").to_solr) }

    before do
      allow_any_instance_of(HiddenMultiSelectInput).to receive(:render_thumbnail).and_return("thumbnail")
      allow(form).to receive(:representations).and_return([asset1, asset2])
      allow(resource).to receive(:representation_uris).and_return([asset1.fedora_uri, asset2.fedora_uri])
      allow(form).to receive(:preferred_representation).and_return(asset1)
      allow(resource).to receive(:preferred_representation_uri).and_return(asset1.fedora_uri)
      render
    end

    it "displays the existing uris" do
      expect(rendered).to include("<input value=\"#{asset1.fedora_uri}\" name=\"agent[representation_uris][]\" type=\"hidden\" id=\"agent_representation_uris\" />")
    end
  end
end
