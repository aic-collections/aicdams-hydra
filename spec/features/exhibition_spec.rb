require 'rails_helper'

describe "CITI exhibitions", order: :defined do
  let(:user) { FactoryGirl.create(:user) }
  before do
    sign_in(user)
    visit(catalog_index_path)
  end

  context "when viewing" do
    it "shows all the information about the resource" do
      fill_in("q", with: "My Very Much Awesome Show ")
      click_button("Go")
      click_link("EX-2846")
      within("dl#show_brief_descriptions") do
        expect(page).to have_content("EX-2846")
        expect(page).to have_content("My Very Much Awesome Show")
        expect(page).to have_content("2004-01-01T00:00:00+00:00")
        expect(page).to have_content("2004-01-01T00:00:00+00:00")
      end
      within("dl#show_descriptions") do
        expect(page).to have_content("2846")
        expect(page).to have_content("EX-2846")
        expect(page).to have_content("2015-10-12")
        expect(page).to have_content("2015-08-01")
        expect(page).to have_content("[WORKING TITLE] My Awesome Show")
        expect(page).to have_content("This is a very awesome show featuring the very much best artist ever lived.")
        expect(page).to have_content("My Very Much Awesome Show")
        expect(page).to have_content("2004-01-01T00:00:00+00:00")
        expect(page).to have_content("1")
        expect(page).to have_content("Active")
      end
    end
  end

  context "when editing" do
    let!(:asset) do
      GenericFile.create.tap do |f|
        f.apply_depositor_metadata(user)
        f.assert_still_image
        f.title = ["Fixture work"]
        f.save
      end
    end

    it "only adds resources" do
      click_link("EX-2846")
      click_link("Edit")
      fill_in("exhibition[document_ids][]", with: asset.id)
      fill_in("exhibition[representation_ids][]", with: asset.id)
      fill_in("exhibition[preferred_representation_ids][]", with: asset.id)
      click_button("Update Exhibition")
      expect(first(:field, "exhibition[document_ids][]").value).to eql asset.id
      expect(first(:field, "exhibition[representation_ids][]").value).to eql asset.id
      expect(first(:field, "exhibition[preferred_representation_ids][]").value).to eql asset.id
      click_link("View Exhibition")
      expect(page).to have_content("Representations")
      expect(page).to have_content("Preferred Representation")
      expect(page).to have_content("Documents")
    end
  end
end
