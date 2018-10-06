# frozen_string_literal: true
require 'rails_helper'

describe "Displaying a CITI work" do
  let(:user)  { create(:user1) }
  let(:agent) { create(:agent, :with_sample_metadata) }
  let(:place) { create(:place, :with_sample_metadata) }
  let(:asset) { create(:asset, pref_label: "A representation of the work", caption: "Asset caption") }

  let(:work) do
    create(:work, :with_sample_metadata,
           artist_uris: [agent.uri],
           current_location_uris: [place.uri],
           representations: [asset.uri],
           preferred_representation: asset.uri
          )
  end

  before { sign_in(user) }

  specify do
    # Search
    visit(root_path)
    fill_in(:q, with: work.pref_label)
    click_button("Go")
    within("#document_#{work.id}") do
      click_link(work.pref_label)
    end

    # Show view
    expect(page).to have_selector("th", text: "Artist")
    expect(page).to have_selector("td", text: agent.pref_label)
    expect(page).to have_selector("th", text: "Current Location")
    expect(page).to have_selector("td", text: place.pref_label)
    expect(page).to have_selector("h3", text: "Representations")
    expect(page).to have_link(asset.pref_label)
    expect(page).to have_link("Add Representations")
    expect(page).to have_link("Add Documentation")
  end
end
