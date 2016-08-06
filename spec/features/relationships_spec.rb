# frozen_string_literal: true
require 'rails_helper'

describe "Relationships of CITI resources" do
  let(:user)  { create(:user1) }
  let(:asset) { create(:department_asset) }
  let(:work)  { create(:work, citi_uid: 'WO-1234', preferred_representation: asset) }

  before do
    sign_in(user)
    visit(relationship_model_path(work.citi_uid, model: 'work'))
  end

  it "renders a page with the resource's relationships" do
    expect(page).not_to have_selector("nav#masthead")
    expect(page).to have_selector("h2", text: "Relationships")
  end
end
