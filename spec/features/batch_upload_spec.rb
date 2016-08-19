# frozen_string_literal: true
require 'rails_helper'

describe "Batch upload" do
  let(:user) { create(:user1) }

  before do
    sign_in_with_js(user)
    visit("/batch_uploads/new")
  end

  it "enforces a workflow" do
    # Intial state of the form
    expect(tabs[1][:class]).to eq("disabled")
    expect(page).to have_select("asset_type_select", selected: '')
    expect(page).not_to have_selector(".fileupload-buttonbar")

    # Choosing the asset type enables the files tab and document type options
    select("Still Image", from: "asset_type_select")
    expect(tabs[1][:class]).not_to eq("disabled")
    expect(hidden_asset_type.value).to eq(AICType.StillImage)
    expect(page).to have_selector(".fileupload-buttonbar")
    click_link("Descriptions")
    select("Imaging", from: "batch_upload_item_document_type_uri")
    select("Event", from: "batch_upload_item_first_document_sub_type_uri")
    select("Lecture", from: "batch_upload_item_second_document_sub_type_uri")
  end
end
