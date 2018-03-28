# frozen_string_literal: true
require 'rails_helper'

describe "Batch upload;" do
  let(:user) { create(:user1) }

  before { sign_in_with_js(user) }

  describe "uploading a new asset;" do
    before { LakeshoreTesting.restore }

    context "signed in as a non-admin;" do
      it "enforces a workflow to ensure the asset is correctly ingested" do
        visit("/batch_uploads/new")
        # Intial state of the form
        expect(tabs[1][:class]).to eq("disabled")
        expect(tabs[0].text).to eq("Files")
        expect(tabs[1].text).to eq("Descriptions")
        expect(tabs[2].text).to eq("Relationships")
        expect(tabs[3].text).to eq("Share")
        expect(page).to have_select("asset_type_select", selected: '')
        expect(page).not_to have_selector(".fileupload-buttonbar")
        expect(page).not_to have_selector(".asset-stillimage")
        expect(page).not_to have_selector(".asset-text")

        # Check requirements status
        expect(page).to have_selector("#required-metadata", text: "Enter required metadata")
        expect(page).to have_selector("#required-files", text: "Add files")
        expect(page).to have_selector("#upload-errors", text: "No failed uploads")
        expect(page).to have_button('Save', disabled: true)

        # Choosing the asset type enables the files tab and displays mime types
        select("Still Image", from: "asset_type_select")
        expect(tabs[1][:class]).not_to eq("disabled")
        expect(hidden_asset_type.value).to eq(AICType.StillImage)
        expect(page).to have_selector(".fileupload-buttonbar")
        expect(page).to have_selector(".asset-stillimage")
        expect(page).to have_selector("li", text: "Adobe Portable Document Format")
        expect(page).not_to have_selector(".asset-text")

        # Upload the wrong type of file
        attach_file('files[]', File.join(fixture_path, "text.txt"), visible: false)
        within("div#fileupload") { sleep 0.1 until page.text.include?("text.txt") }

        # Check requirements status
        expect(page).to have_selector("#required-metadata", text: "Enter required metadata")
        expect(page).to have_selector("#required-files", text: "Files requirement complete")
        expect(page).to have_selector("#upload-errors", text: "Files failed to upload. Please remove them from the queue before saving.")
        expect(page).to have_button('Save', disabled: true)

        # Delete bad file and upload a correct one
        click_button("Delete")
        within("div#fileupload") { sleep 0.1 while page.text.include?("text.txt") }
        attach_file('files[]', File.join(fixture_path, "sun.png"), visible: false)
        within("div#fileupload") do
          sleep 0.1 until page.text.include?("Preferred Title")
          expect(page).to have_selector("input#pref_label_1")
        end

        # Check requirements status
        expect(page).to have_selector("#required-metadata", text: "Enter required metadata")
        expect(page).to have_selector("#required-files", text: "Files requirement complete")
        expect(page).to have_selector("#upload-errors", text: "No failed uploads")
        expect(page).to have_button('Save', disabled: true)

        # Add descriptions
        click_link("Descriptions")
        select("Imaging", from: "batch_upload_item_document_type_uri")
        select("Event Photography", from: "batch_upload_item_first_document_sub_type_uri")
        select("Lecture", from: "batch_upload_item_second_document_sub_type_uri")

        # Check requirements status
        expect(page).to have_selector("#required-metadata", text: "Metadata requirement complete")
        expect(page).to have_selector("#required-files", text: "Files requirement complete")
        expect(page).to have_selector("#upload-errors", text: "No failed uploads")
        expect(page).to have_button('Save', disabled: false)

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

      it "does not display imaging_uid field" do
        visit("/batch_uploads/new#metadata")
        expect(page).not_to have_field("Imaging UID")
      end
    end

    context "signed in as an admin;" do
      let(:user) { create(:admin) }
      it "does not display imaging_uid field" do
        visit("/batch_uploads/new#metadata")
        expect(page).not_to have_field("Imaging UID")
      end
    end
  end

  context "when passing relationship parameters in the url;" do
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

  context "with an external resoure;" do
    before { LakeshoreTesting.restore }

    it "creates a new asset without any local files" do
      visit("/batch_uploads/new")
      select("Still Image", from: "asset_type_select")
      fill_in("External File", with: "http://www.google.com")
      fill_in("Label for External File", with: "Google link")
      click_link("Descriptions")
      select("Imaging", from: "batch_upload_item_document_type_uri")
      select("Event Photography", from: "batch_upload_item_first_document_sub_type_uri")
      select("Lecture", from: "batch_upload_item_second_document_sub_type_uri")

      # This has no local file, so characterization will not be performed
      expect(CharacterizeJob).not_to receive(:perform_later)
      click_button("Save")

      within("div#documents") do
        expect(page).to have_content("Display all details of Google link")
      end
    end
  end
end
