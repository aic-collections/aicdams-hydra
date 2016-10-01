# frozen_string_literal: true
require 'rails_helper'

describe "Creating a new collection" do
  let(:user) { create(:user1) }
  before do
    sign_in_with_js(user)
    visit(new_polymorphic_path([main_app, Collection]))
  end

  it "renders the form" do
    expect(page).to have_content("Create New Collection")
  end
end
