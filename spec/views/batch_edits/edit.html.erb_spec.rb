# frozen_string_literal: true
require 'rails_helper'

describe "batch_edits/edit.html.erb" do
  let(:ability) { Ability.new(user) }
  let(:asset)   { build(:asset, :with_id, pref_label: "Batch edit asset") }
  let(:form)    { BatchEditForm.new(GenericWork.new, ability, [asset.id]) }
  let(:page)    { Capybara::Node::Simple.new(rendered) }

  before do
    index_assets(asset)
    assign(:form, form)
    stub_template '_form_descriptions.html.erb' => 'form_descriptions'
    stub_template 'curation_concerns/base/_form_permission.html.erb' => 'form_permission'
    stub_template 'curation_concerns/base/_form_share.html.erb' => 'form_share'
    allow(controller).to receive(:current_user).and_return(user)
    render
  end

  context "with an admin user" do
    let(:user) { create(:admin) }

    it "displays the permissions and share form" do
      expect(page).to have_content("form_permission")
      expect(page).to have_content("form_share")
    end
  end

  context "with a non-admin user" do
    let(:user) { create(:user1) }

    it "only displays the permissions form" do
      expect(page).to have_content("form_permission")
      expect(page).not_to have_content("form_share")
    end
  end
end
