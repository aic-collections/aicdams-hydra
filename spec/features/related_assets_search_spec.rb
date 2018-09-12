# frozen_string_literal: true
require 'rails_helper'

describe "Searching for related assets" do
  let(:user) { create(:user1) }

  before do
    sign_in(user)
  end

  it 'displays search results for assets related to CITI resources' do
    visit(form_related_assets_path)
    expect(page).to have_content("Related Asset Search")
    click_button("Search")
    expect(page).to have_content("Search Sufia")
  end
end
