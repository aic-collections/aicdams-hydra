# frozen_string_literal: true
require 'rails_helper'

describe "Visting the home page", type: :feature do
  let(:user) { create(:user1) }
  before do
    sign_in(user)
    visit(root_path)
  end

  it "renders the homepage" do
    expect(page).to have_content "Sufia"
    expect(page).to have_content "Advanced Search"
    within("div#advanced_search") do
      expect(page).to have_content "Contributor"
      expect(page).to have_content "Creator"
      expect(page).to have_content "Title"
    end
    within("#search-form-header") do
      expect(page).to have_link("All Resources")
      expect(page).to have_link("All Assets")
      expect(page).to have_link("Works")
      expect(page).to have_link("Places")
      expect(page).to have_link("Exhibitions")
      expect(page).to have_link("Shipments")
      expect(page).to have_link("Transactions")
      expect(page).to have_link("Agents")
    end
  end
end
