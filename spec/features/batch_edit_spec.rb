# frozen_string_literal: true
require "rails_helper"

describe "Batch management of works", type: :feature do
  include BatchEditActions

  let(:current_user) { create(:user1) }
  let!(:asset1)      { create(:asset, :with_metadata, pref_label: "Batch Asset 1") }
  let!(:asset2)      { create(:asset, :with_metadata, pref_label: "Batch Asset 2") }

  before(:all) { LakeshoreTesting.restore }

  before do
    sign_in_with_named_js(:batch_edit, current_user, disable_animations: true)
    visit "/dashboard/works"
  end

  context "when editing and viewing multiple works" do
    before do
      check("check_all")
      click_on("batch-edit")
    end

    it "edits a field and displays the changes", js: true do
      # Edit fields
      batch_edit_fields.each do |field|
        fill_in_batch_edit_field(field, with: "Updated batch #{field}")
      end

      # Edit permissions
      click_link("Share")
      within("#form_permissions") do
        choose("AIC")
        click_button("Save changes")
        sleep 0.1 until page.text.include?('Changes Saved')
      end

      asset1.reload
      asset2.reload
      batch_edit_fields.each do |field|
        expect(asset1.send(field)).to contain_exactly("Updated batch #{field}")
        expect(asset2.send(field)).to contain_exactly("Updated batch #{field}")
      end
      expect(asset1.visibility).to eq("authenticated")
      expect(asset2.visibility).to eq("authenticated")
    end

    it "displays the field's existing values" do
      expect(page).to have_content("Changes will be applied to the following 2 assets:")
      expect(page).to have_field("Language", with: asset1.language.first)
      expect(page).to have_field("Publisher", with: asset1.publisher.first)
      expect(page).to have_select("Publish Channels", disabled: true)
      expect(page).to have_select("Status", selected: "Active")
    end
  end

  context "when selecting multiple works for deletion", js: true do
    subject { GenericWork.count }
    before do
      check "check_all"
      click_button "Delete Selected"
    end
    it { is_expected.to be_zero }
  end
end
