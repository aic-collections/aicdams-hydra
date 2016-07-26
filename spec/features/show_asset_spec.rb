# frozen_string_literal: true
require 'rails_helper'

describe "Displaying an asset" do
  let(:user)  { create(:user1) }
  let(:asset) { create(:department_asset) }

  before do
    create(:exhibition, preferred_representation: asset)
    create(:work, representations: [asset])
    create(:shipment, documents: [asset])
    sign_in(user)
    visit(polymorphic_path([main_app, asset]))
  end

  it "shows the full set of relationships" do
    expect(page).to have_selector("h3", text: "Documents")
    expect(page).to have_selector("h3", text: "Representations")
    expect(page).to have_selector("h3", text: "Preferred Representation")
    expect(page).to have_link("Sample Exhibition")
    expect(page).to have_link("Sample Work")
    expect(page).to have_link("Sample Shipment")
  end
end
