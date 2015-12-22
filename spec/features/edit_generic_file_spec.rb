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
      skip "disabled for beta1 release"
      visit sufia.edit_generic_file_path(file)
      expect(page).to have_content("Edit #{title}")
      expect(page).not_to have_button("Category")
      fill_in("generic_file[comments_attributes][0][content]", with: comment0)
      click_button("upload_submit")
      expect(find_field("generic_file[comments_attributes][0][content]").value).to eql comment0
      expect(page).to have_button("Category")
      fill_in("generic_file[comments_attributes][1][content]", with: comment1)
      within("div.comments-editor") { find_button('Add').click }
      fill_in("generic_file[comments_attributes][2][content]", with: comment2)
      click_button("upload_submit")
      expect(find_field("generic_file[comments_attributes][0][content]").value).to eql comment0
      expect(find_field("generic_file[comments_attributes][1][content]").value).to eql comment1
      expect(find_field("generic_file[comments_attributes][2][content]").value).to eql comment2
      within("div.comments-editor") { first(:button, "Remove").click }
      click_button("upload_submit")
      expect(find_field("generic_file[comments_attributes][0][content]").value).to eql comment1
      expect(find_field("generic_file[comments_attributes][1][content]").value).to eql comment2
    end
  end
end