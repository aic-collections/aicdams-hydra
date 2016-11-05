# frozen_string_literal: true

require 'rails_helper'

def add_artists_and_current_locations_to_work(work, agent, place)
  work.artist_uris = [agent.uri]
  work.current_location_uris = [place.uri]
  work.save!
end

describe "Displaying a Citi Work" do
  let(:user) { create(:user1) }
  let(:work) { create(:work, :with_sample_metadata) }
  let(:agent) { create(:agent, :with_sample_metadata) }
  let(:place) { create(:place, :with_sample_metadata) }
  before do
    add_artists_and_current_locations_to_work(work, agent, place)
    sign_in(user)
  end

  it "renders Artist and Current Place metadata" do
    visit(root_path)
    fill_in(:q, with: work.pref_label)
    click_button("Go")
    within("#document_#{work.id}") do
      click_link("The Great Sidewalk Gum")
    end

    expect(page).to have_selector("th", text: "Artist")
    expect(page).to have_selector("td", text: "Pablo Picasso (1881-1973)")
    expect(page).to have_selector("th", text: "Current Location")
    expect(page).to have_selector("td", text: "Sample Place")
  end
end
