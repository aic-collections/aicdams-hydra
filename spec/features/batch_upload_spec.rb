# frozen_string_literal: true
require 'rails_helper'

describe "Batch upload" do
  let(:user) { create(:user1) }

  before { sign_in_with_js(user) }

  context "when uploading a new asset" do
    before { LakeshoreTesting.restore }

    it "enforces a workflow to ensure the asset is correctly ingested" do
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

      # Upload a file
      attach_file('files[]', File.join(fixture_path, "sun.png"), visible: false)
      within("div#fileupload") do
        sleep 0.1 until page.text.include?("Preferred Title")
        expect(page).to have_selector("input#pref_label_1")
      end

      # Add descriptions
      click_link("Descriptions")
      select("Imaging", from: "batch_upload_item_document_type_uri")
      select("Event Photography", from: "batch_upload_item_first_document_sub_type_uri")
      select("Lecture", from: "batch_upload_item_second_document_sub_type_uri")

      # Displaying hints
      within("div.batch_upload_item_language") do
        expect(page).to have_content("The language of the asset content.")
      end

      # Save the asset, but skip characterization and derivative creation
      expect(CharacterizeJob).to receive(:perform_later)
      click_button("Save")

      # Viewing My Assets

      within("div#documents") do
        expect(page).to have_content("Listing of items you have deposited in LAKE")
        expect(page).to have_link("sun.png")
      end
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
