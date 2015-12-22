require 'rails_helper'

describe "CITI works", order: :defined do
  let(:user) { FactoryGirl.create(:user) }
  before do
    sign_in(user)
    visit(catalog_index_path)
  end

  context "when viewing" do
    it "shows all the information about the resource" do
      fill_in("q", with: "Sidewalk Gum")
      click_button("Go")
      click_link("The Great Sidewalk Gum")
      within("dl#show_brief_descriptions") do
        expect(page).to have_content("WO-43523")
        expect(page).to have_content("1999.397")
        expect(page).to have_content("2001-01-01T00:00:00+00:00")
        expect(page).to have_content("2014-04-16T14:29:00+00:00")
      end
      within("dl#show_descriptions") do
        expect(page).to have_content("The Great Sidewalk Gum")
        expect(page).to have_content("Gift of Mr. Dummy Lee & Mrs. Parrot Funkaroo")
        expect(page).to have_xpath("//span[@itemprop = 'department']", text: "3")
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
      click_link("The Great Sidewalk Gum")
      click_link("Edit")
      fill_in("work[document_ids][]", with: asset.id)
      fill_in("work[representation_ids][]", with: asset.id)
      fill_in("work[preferred_representation_ids][]", with: asset.id)
      fill_in("work[asset_ids][]", with: asset.id)
      click_button("Update Work")
      expect(first(:field, "work[document_ids][]").value).to eql asset.id
      expect(first(:field, "work[representation_ids][]").value).to eql asset.id
      expect(first(:field, "work[preferred_representation_ids][]").value).to eql asset.id
      expect(first(:field, "work[asset_ids][]").value).to eql asset.id
      click_link("View Work")
      expect(page).to have_content("Assets")
      expect(page).to have_content("Representations")
      expect(page).to have_content("Preferred Representation")
      expect(page).to have_content("Documents")
    end
  end
end
