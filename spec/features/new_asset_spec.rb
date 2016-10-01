# frozen_string_literal: true
require 'rails_helper'

describe "Creating a new asset" do
  let(:user) { create(:user1) }
  before do
    sign_in_with_js(user)
    visit(new_polymorphic_path([main_app, GenericWork]))
  end

  it "enforces a workflow" do
    # Intial state of the form
    expect(tabs[1][:class]).to eq("disabled")
    expect(page).to have_select("asset_type_select", selected: '')
    expect(document_type_select_options.count).to eq(1)
    expect(document_type_select_options.first.text).to eq("Please select asset type first")

    # Choosing the asset type enables the files tab and document type options
    select("Still Image", from: "asset_type_select")
    expect(tabs[1][:class]).not_to eq("disabled")
    expect(hidden_asset_type.value).to eq(AICType.StillImage)
    expect(document_type_select_options.count).to eq(10)
    select("Imaging", from: "generic_work_document_type_uri")
    select("Event", from: "generic_work_first_document_sub_type_uri")
    select("Lecture", from: "generic_work_second_document_sub_type_uri")
  end
end
