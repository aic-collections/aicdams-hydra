require 'rails_helper'

describe "CITI actors", order: :defined do
  let(:user) { FactoryGirl.create(:user) }
  before do
    sign_in(user)
    visit(catalog_index_path)
  end

  context "when viewing" do
    it "shows all the information about the resource" do
      fill_in("q", with: "Pablo Picasso")
      click_button("Go")
      click_link("Pablo Picasso (1881-1973)")
      within("dl#show_brief_descriptions") do
        expect(page).to have_content("AC-19646")
        expect(page).to have_content("2015-11-12T00:00:00+00:00")
        expect(page).to have_content("2015-11-24T00:00:00+00:00")
      end
      within("dl#show_descriptions") do
        expect(page).to have_content("Pablo Picasso (1881-1973)")
        expect(page).to have_content("19646")
        expect(page).to have_content("1881-10-25")
        expect(page).to have_content("1973")
        expect(page).to have_content("1973-08-04")
        expect(page).to have_content("AC-19646")
        expect(page).to have_content("2015-11-12T00:00:00+00:00 ")
        expect(page).to have_content("1881")
        expect(page).to have_content("Pablo Diego José Francisco de Paula Juan Nepomuceno María de los Remedios Cipriano de la Santísima Trinidad Ruiz y Picasso")
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
      click_link("Pablo Picasso (1881-1973)")
      click_link("Edit")
      fill_in("actor[document_ids][]", with: asset.id)
      fill_in("actor[representation_ids][]", with: asset.id)
      fill_in("actor[preferred_representation_ids][]", with: asset.id)
      click_button("Update Actor")
      expect(first(:field, "actor[document_ids][]").value).to eql asset.id
      expect(first(:field, "actor[representation_ids][]").value).to eql asset.id
      expect(first(:field, "actor[preferred_representation_ids][]").value).to eql asset.id
      click_link("View Actor")
      expect(page).to have_content("Representations")
      expect(page).to have_content("Preferred Representation")
      expect(page).to have_content("Documents")
    end
  end
end
