require 'rails_helper'

describe "CITI shipments", order: :defined do
  let(:user) { FactoryGirl.create(:user) }
  before do
    sign_in(user)
    visit(catalog_index_path)
  end

  context "when viewing" do
    it "shows all the information about the resource" do
      fill_in("q", with: "SH-3469")
      click_button("Go")
      click_link("SH-3469")
      within("dl#show_brief_descriptions") do
        expect(page).to have_content("SH-3469")
        expect(page).to have_content("2015-01-25T00:00:00+00:00")
        expect(page).to have_content("2015-06-23T00:00:00+00:00")
      end
      within("dl#show_descriptions") do
        expect(page).to have_content("SH-3469")
        expect(page).to have_content("2015-01-25T00:00:00+00:00")
        expect(page).to have_content("2015-06-23T00:00:00+00:00")
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
      click_link("SH-3469")
      click_link("Edit")
      fill_in("shipment[document_ids][]", with: asset.id)
      fill_in("shipment[representation_ids][]", with: asset.id)
      fill_in("shipment[preferred_representation_ids][]", with: asset.id)
      click_button("Update Shipment")
      expect(first(:field, "shipment[document_ids][]").value).to eql asset.id
      expect(first(:field, "shipment[representation_ids][]").value).to eql asset.id
      expect(first(:field, "shipment[preferred_representation_ids][]").value).to eql asset.id
      click_link("View Shipment")
      expect(page).to have_content("Representations")
      expect(page).to have_content("Preferred Representation")
      expect(page).to have_content("Documents")
    end
  end
end
