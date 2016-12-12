# frozen_string_literal: true
require 'rails_helper'

describe "Batch upload" do
  let(:user) { create(:user1) }

  before { sign_in_with_js(user) }

  it "enforces a workflow" do
    visit("/batch_uploads/new")
    # Intial state of the form
    expect(tabs[1][:class]).to eq("disabled")
    expect(page).to have_select("asset_type_select", selected: '')
    expect(page).not_to have_selector(".fileupload-buttonbar")
    expect(page).not_to have_selector(".asset-stillimage")
    expect(page).not_to have_selector(".asset-text")

    # Choosing the asset type enables the files tab and displays mime types
    select("Still Image", from: "asset_type_select")
    expect(tabs[1][:class]).not_to eq("disabled")
    expect(hidden_asset_type.value).to eq(AICType.StillImage)
    expect(page).to have_selector(".fileupload-buttonbar")
    expect(page).to have_selector(".asset-stillimage")
    expect(page).to have_selector("li", text: "Adobe Portable Document Format")
    expect(page).not_to have_selector(".asset-text")
    click_link("Descriptions")
    select("Imaging", from: "batch_upload_item_document_type_uri")
    select("Event", from: "batch_upload_item_first_document_sub_type_uri")
    select("Lecture", from: "batch_upload_item_second_document_sub_type_uri")

    # Displaying hints
    within("div.batch_upload_item_language") do
      expect(page).to have_content("The language of the asset content.")
    end
  end

  context "when passing relationship parameters in the url" do
    let(:work) { create(:work, citi_uid: "1234") }

    it "displays representations from the parameterized url" do
      visit("/batch_uploads/new?relationship=representation_for&citi_type=Work&citi_uid[]=#{work.citi_uid}")
      click_link("Relationships")
      within("table.representations_for") do
        expect(page).to have_selector("td", text: "Sample Work")
      end
    end

    it "displays documents from the parameterized url" do
      visit("/batch_uploads/new?relationship=documentation_for&citi_type=Work&citi_uid[]=#{work.citi_uid}")
      click_link("Relationships")
      within("table.documents_for") do
        expect(page).to have_selector("td", text: "Sample Work")
      end
    end
  end
end
