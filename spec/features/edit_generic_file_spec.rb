require 'rails_helper'

describe "Editing generic files" do
  let(:user) { FactoryGirl.create(:user) }
  let(:title) { "Sample file to edit" }
  let(:file) do
    GenericFile.new.tap do |f|
      f.title = [title]
      f.apply_depositor_metadata(user.user_key)
      f.assert_still_image
      f.save!
    end
  end

  before { sign_in user }

  context "with comments" do
    let(:comment0) { "The first comment"  }
    let(:comment1) { "The second comment" }
    let(:comment2) { "The third comment"  }

    it "supports adding and removing" do
      visit sufia.edit_generic_file_path(file)
      expect(page).to have_content("Edit #{title}")
      expect(page).not_to have_button("Category")
      click_button("upload_submit")
      expect(page).to have_button("Category")
      within("div.comments-editor") { find_button('Add').click }
      click_button("upload_submit")
      within("div.comments-editor") { first(:button, "Remove").click }
      click_button("upload_submit")
    end
  end
end
