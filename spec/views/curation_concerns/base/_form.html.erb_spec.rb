# frozen_string_literal: true
require 'rails_helper'

describe 'curation_concerns/base/_form.html.erb' do
  let(:user)    { create(:user1) }
  let(:ability) { double }
  let(:form)    { CurationConcerns::GenericWorkForm.new(work, ability) }
  let(:page)    { Capybara::Node::Simple.new(rendered) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
    assign(:form, form)
  end

  context "with a new asset" do
    let(:work) { GenericWork.new }
    before do
      allow(view).to receive(:action_name).and_return('new')
      render
    end
    it "includes select options for asset type" do
      expect(rendered).to include("<option value=\"#{AICType.StillImage}\">Still Image</option>")
      expect(rendered).to include("<option value=\"#{AICType.Text}\">Text</option>")
    end
    it "does not show the status select input" do
      expect(rendered).not_to include("generic_work_status_uri")
    end
    it "displays the correct visibility options" do
      expect(page).to have_checked_field('generic_work_visibility_department')
    end
    it "displays the first document type selection option" do
      expect(page).to have_select('generic_work_document_type_uri')
      expect(page).not_to have_select('generic_work_first_document_sub_type_uri')
      expect(page).not_to have_select('generic_work_second_document_sub_type_uri')
    end
    it "displays the correct field labels" do
      expect(page).to have_selector("label", text: "Original Source")
      expect(page).to have_selector("label", text: "Image View")
      expect(page).to have_selector("label", text: "Image Capture Light Type")
      expect(page).to have_selector("label", text: "Image Compositing")
      expect(page).to have_selector("label", text: "Description")
    end
  end

  context "when editing an existing asset" do
    let(:work) { create(:asset) }
    before { render }

    it "renders the asset type as a hidden field with the current value" do
      expect(rendered).to include("type=\"hidden\" value=\"#{AICType.StillImage}\"")
    end
    it "renders the existing status selected" do
      expect(rendered).to include("<option selected=\"selected\" value=\"#{StatusType.active.uri}\">Active</option>")
    end
  end

  context "with existing document types" do
    let(:work) do
      create(:asset,
             document_type_uri: "http://doctype-uri",
             first_document_sub_type_uri: "http://first-sub-type-uri",
             second_document_sub_type_uri: "http://second-sub-type-uri"
            )
    end
    before do
      allow(view).to receive(:action_name).and_return('edit')
      render
    end

    it "renders existing uris as data attributes" do
      expect(rendered).to include('data-uri="http://doctype-uri">')
      expect(rendered).to include('data-uri="http://first-sub-type-uri">')
      expect(rendered).to include('data-uri="http://second-sub-type-uri">')
    end
  end

  context "with singular terms using list items" do
    let(:item) { create(:list_item) }
    let(:addl) { create(:list_item, pref_label: "Additional Item") }
    let(:work) { create(:asset, compositing: item.uri,
                                light_type: item.uri,
                                digitization_source: item.uri,
                                view: [item.uri, addl.uri]) }

    before do
      allow(BaseVocabulary).to receive(:all).and_return([item, addl])
      render
    end

    subject { Capybara::Node::Simple.new(rendered) }

    it "renders the selected item" do
      is_expected.to have_select('generic_work_compositing_uri', selected: item.pref_label)
      is_expected.to have_select('generic_work_light_type_uri', selected: item.pref_label)
      is_expected.to have_select('generic_work_digitization_source_uri', selected: item.pref_label)
      within("div.generic_work_view_uris") do
        is_expected.to have_content("<option selected=\"selected\" value=\"#{item.uri}\">#{item.pref_label}</option>")
        is_expected.to have_content("<option selected=\"selected\" value=\"#{addl.uri}\">#{addl.pref_label}</option>")
      end
    end
  end
end
