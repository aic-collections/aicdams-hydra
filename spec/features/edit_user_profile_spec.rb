# frozen_string_literal: true
require 'rails_helper'

describe "Editing a user's profile" do
  let(:user) { create(:user1) }
  before do
    sign_in(user)
    visit(root_path)
  end

  it "let's the user change the values in their profile" do
    click_link("Edit Profile")
    fill_in('user_twitter_handle', with: "tweety")
    click_button("Save Profile")
    expect(page).to have_content("Your account has been updated successfully")
  end
end
