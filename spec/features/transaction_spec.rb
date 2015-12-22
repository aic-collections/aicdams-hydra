require 'rails_helper'

describe "CITI transactions", order: :defined do
  let(:user) { FactoryGirl.create(:user) }
  before do
    sign_in(user)
    visit(catalog_index_path)
  end

  context "when viewing" do
    it "shows all the information about the resource" do
      fill_in("q", with: "TR-123456")
      click_button("Go")
      click_link("TR-123456")
      within("dl#show_brief_descriptions") do
        expect(page).to have_content("TR-123456")
        expect(page).to have_content("2004-01-01T00:00:00+00:00")
        expect(page).to have_content("2010-01-01T00:00:00+00:00")
      end
      within("dl#show_descriptions") do
        expect(page).to have_content("TR-123456")
        expect(page).to have_content("2004-01-01T00:00:00+00:00")
        expect(page).to have_content("2010-01-01T00:00:00+00:00")
        expect(page).to have_content("123456")
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
      click_link("TR-123456")
      click_link("Edit")
      fill_in("transaction[document_ids][]", with: asset.id)
      fill_in("transaction[representation_ids][]", with: asset.id)
      fill_in("transaction[preferred_representation_ids][]", with: asset.id)
      click_button("Update Transaction")
      expect(first(:field, "transaction[document_ids][]").value).to eql asset.id
      expect(first(:field, "transaction[representation_ids][]").value).to eql asset.id
      expect(first(:field, "transaction[preferred_representation_ids][]").value).to eql asset.id
      click_link("View Transaction")
      expect(page).to have_content("Representations")
      expect(page).to have_content("Preferred Representation")
      expect(page).to have_content("Documents")
    end
  end
end
