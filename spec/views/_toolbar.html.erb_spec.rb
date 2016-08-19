# frozen_string_literal: true
require 'rails_helper'

describe '/_toolbar.html.erb' do
  let(:user) { create(:user1) }

  before do
    allow(view).to receive(:user_signed_in?).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
    allow(view).to receive(:can?).and_call_original
  end

  before { render }

  it "displays the correct concerns" do
    expect(rendered).not_to include("New Asset")
    expect(rendered).not_to include("New Exhibition")
    expect(rendered).not_to include("New Agent")
    expect(rendered).not_to include("New Work")
  end
end
