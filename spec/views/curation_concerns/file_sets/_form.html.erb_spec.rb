# frozen_string_literal: true
require 'rails_helper'

describe 'curation_concerns/file_sets/_form.html.erb', type: :view do
  let(:user)     { create(:user1) }
  let(:parent)   { create(:still_image_asset) }
  let(:file_set) { create(:file_set) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
    render 'curation_concerns/file_sets/form.html.erb', curation_concern: file_set, parent: parent
  end

  context "without additional users" do
    it "draws the edit form without error" do
      expect(rendered).to have_css("input")
    end
  end
end
