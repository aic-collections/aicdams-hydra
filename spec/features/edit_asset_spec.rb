# frozen_string_literal: true
require 'rails_helper'

describe "Editing assets" do
  let!(:asset) { create(:asset, :with_metadata) }
  let!(:agent) { create(:agent, representation_uris: [asset.uri], preferred_representation_uri: asset.uri) }
  let!(:work)  { create(:work, representation_uris: [asset.uri]) }

  let(:user) { create(:user1) }

  before do
    sign_in_with_js(user)
    visit(edit_polymorphic_path(asset))
  end

  it "renders the form with existing values" do
    click_link("Descriptions")
    expect(selected_document_type).to eq(asset.document_type_uri)
    expect(selected_first_document_sub_type).to eq(asset.first_document_sub_type_uri)
    expect(selected_second_document_sub_type).to eq(asset.second_document_sub_type_uri)
    expect(generic_work_hidden_asset_type.value).to eq(AICType.StillImage)
    expect(selected_publish_channel).to eq(asset.publish_channel_uris.first)
    expect(page).to have_field("Preferred Title", with: asset.pref_label)
    expect(page).to have_field("Description", with: asset.description.first)
    expect(page).to have_field("Alternative label", with: asset.alt_label.first)
    expect(page).to have_field("Language", with: asset.language.first)
    expect(page).to have_field("Capture Device", with: asset.capture_device)
    expect(page).to have_select("Status", selected: "Active")
    expect(page).to have_select("Publish Channels", selected: "Web", disabled: true)
    expect(page).to have_field("View Notes", with: asset.view_notes.first)
    expect(page).to have_field("Visual Surrogate", with: asset.visual_surrogate)
    expect(page).to have_field("Caption", with: asset.caption)

    # non-admin can't see imaging_uid field
    expect(page).not_to have_field("Imaging UID", with: asset.imaging_uid.first)

    expect(page).not_to have_content('string multi_value optional form-control generic_work_alt_label form-control multi-text-field')

    # Displaying hints
    within("div.generic_work_language") do
      expect(page).to have_content("The language of the asset content.")
    end
    within("div.generic_work_caption") do
      expect(page).to have_content("Non-Object Caption")
      expect(page).to have_content("A 30-character alphanumeric string serving as a caption for the asset")
    end

    click_link "Files"
    expect(page).to have_selector("li", text: "Adobe Portable Document Format")
    expect(page).to have_selector('.asset-stillimage')
    expect(page).not_to have_selector('.asset-text')
    expect(page).to have_field("URL", with: asset.external_resources.first)

    click_link "Relationships"
    within("table.representations_for") do
      expect(page).to have_content(agent.pref_label)
      expect(page).to have_content(work.pref_label)
    end
  end

  xit "selects a new doctype that has no sub or sub-subtypes and persists it" do
    visit(edit_polymorphic_path(asset))

    find('select#generic_work_document_type_uri').select("Development")
    click_button("Save")

    visit(polymorphic_path(asset))

    expect(page).to have_content("Development")
    expect(page).not_to have_content("Imaging > Event Photography > Lecture")
    expect(page).not_to have_content("Development > Lecture")
  end
end
