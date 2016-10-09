# frozen_string_literal: true
require 'rails_helper'

describe "The dashboard" do
  let(:user)  { create(:user1) }

  before { sign_in(user) }

  context "with my assets" do
    it "list assets belonging to the user" do
      visit("/dashboard/works")
      within("#search-form-header") do
        expect(page).to have_link("My Assets")
      end
    end
  end
end
