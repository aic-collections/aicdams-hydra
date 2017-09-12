# frozen_string_literal: true
require 'rails_helper'

describe "my/sort_and_per_page.html.erb" do
  let(:mock_response) { { "numFound" => 1 } }

  before do
    assign(:response, double(response: mock_response))
    allow(view).to receive(:on_my_works?).and_return(true)
    allow(view).to receive(:current_user).and_return(user)
    render "my/sort_and_per_page"
  end

  context "with an admin user" do
    let(:user) { create(:admin) }
    it "renders the batch edit button" do
      expect(rendered).to have_selector("#batch-edit")
    end
  end

  context "with a non-admin user" do
    let(:user) { create(:user1) }
    it "does not render the batch edit button" do
      expect(rendered).not_to have_selector("#batch-edit")
    end
  end
end
