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
  end
end
