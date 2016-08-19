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
  end
end
