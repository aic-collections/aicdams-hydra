# frozen_string_literal: true
require 'rails_helper'

describe "Editing assets" do
  let!(:asset) { create(:asset, :with_metadata) }

  let(:user) { create(:user1) }

  before do
    sign_in_with_js(user)
    visit(edit_polymorphic_path(asset))
  end

  it "renders the form with existing values" do
    expect(selected_document_type).to eq("http://definitions.artic.edu/doctypes/Imaging")
    expect(selected_first_document_sub_type).to eq("http://definitions.artic.edu/doctypes/EventPhotography")
    expect(selected_second_document_sub_type).to eq("http://definitions.artic.edu/doctypes/Lecture")
    expect(generic_work_hidden_asset_type.value).to eq("http://definitions.artic.edu/ontology/1.0/type/StillImage")
    expect(selected_publish_channel).to eq("http://definitions.artic.edu/publish_channel/Web")

    expect(page).not_to have_content('string multi_value optional form-control generic_work_alt_label form-control multi-text-field')

    # Displaying hints
    within("div.generic_work_language") do
      expect(page).to have_content("The language of the asset content.")
    end

    click_link "Files"
    expect(page).to have_selector("li", text: "Adobe Portable Document Format")
    expect(page).to have_selector('.asset-stillimage')
    expect(page).not_to have_selector('.asset-text')
  end

  it "selects a new doctype that has no sub or sub-subtypes and persists it" do
    visit(edit_polymorphic_path(asset))

    find('select#generic_work_document_type_uri').select("Development")
    click_button("Save")

    visit(polymorphic_path(asset))

    expect(page).to have_content("Development")
    expect(page).not_to have_content("Imaging > Event Photography > Lecture")
    expect(page).not_to have_content("Development > Lecture")
  end
end
