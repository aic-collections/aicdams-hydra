# frozen_string_literal: true
require 'rails_helper'

describe 'curation_concerns/base/_form_share.html.erb' do
  let(:user)    { create(:user1) }
  let(:work)    { create(:department_asset) }
  let(:ability) { double }
  let(:form)    { CurationConcerns::GenericWorkForm.new(work, ability) }

  let(:page) do
    view.simple_form_for form do |f|
      render 'curation_concerns/base/form_share.html.erb', f: f
    end
    Capybara::Node::Simple.new(rendered)
  end

  before { allow(controller).to receive(:current_user).and_return(user) }

  it "hides groups maintained by visibility" do
    expect(page).not_to have_content('admin')
    expect(page).not_to have_content('registered')
    expect(page).not_to have_content('department')
  end
end
