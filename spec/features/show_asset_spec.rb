# frozen_string_literal: true
require 'rails_helper'

describe "Displaying an asset" do
  let(:user)  { create(:user1) }
  let(:asset) { create(:department_asset, :with_metadata) }

  before do
    create(:exhibition, preferred_representation: asset)
    create(:work, representations: [asset])
    create(:shipment, documents: [asset])
    sign_in(user)
  end

  it "renders metadata" do
    # Display in the recent documents list
    visit(root_path)
    within("#recent_docs") do
      expect(page).to have_link(asset.keyword.first.pref_label)
      expect(page).to have_link(asset.pref_label)
    end

    # Index search results
    fill_in(:q, with: asset.pref_label)
    click_button("Go")
    within("#document_#{asset.id}") do
      expect(page).to have_selector("th", text: "Title")
      expect(page).to have_selector("td", text: asset.pref_label)
      expect(page).to have_selector("th", text: AIC.uid.label)
      expect(page).to have_selector("td", text: asset.uid)
      expect(page).to have_selector("th", text: AIC.department.label)
      expect(page).to have_selector("td", text: asset.dept_created.pref_label)
      expect(page).to have_selector("th", text: AIC.documentType.label)
      expect(page).to have_selector("td", text: "Imaging > Event Photography > Lecture")
      click_link(asset.pref_label)
    end

    # Show page view
    expect(page).to have_selector("h3", text: "Preferred Representation Of")
    expect(page).to have_selector("h3", text: "Representation Of")
    expect(page).to have_selector("h3", text: "Documentation For")
    expect(page).to have_link("Sample Exhibition")
    expect(page).to have_link("Sample Work")
    expect(page).to have_link("Sample Shipment")

    # Title and description
    expect(page).to have_selector("h1", text: asset.pref_label)
    expect(page).to have_selector("p.work_description", text: asset.description.first)

    # Attributes
    within("table.attributes") do
      expect(page).to have_selector("li.document_types", text: "Imaging > Event Photography > Lecture")
      expect(page).to have_selector("li.view", text: asset.view.first.pref_label)
      expect(page).to have_selector("li.keyword", text: asset.keyword.first.pref_label)
      expect(page).to have_selector("li.capture_device", text: asset.capture_device)
      expect(page).to have_selector("li.digitization_source", text: asset.digitization_source.pref_label)
      expect(page).to have_content(asset.legacy_uid.first)
      expect(page).to have_content(asset.legacy_uid.last)
      expect(page).to have_selector("li.compositing", text: asset.compositing.pref_label)
      expect(page).to have_selector("li.light_type", text: asset.light_type.pref_label)
      expect(page).to have_selector("li.imaging_uid", text: asset.imaging_uid.first)
      expect(page).to have_selector("li.transcript", text: asset.transcript)
      expect(page).to have_selector("li.status", text: asset.status.pref_label)
      expect(page).to have_selector("li.dept_created", text: asset.dept_created.pref_label)
      expect(page).to have_selector("li.aic_depositor", text: asset.aic_depositor.nick)
      expect(page).to have_selector("li.batch_uid", text: asset.batch_uid)
      expect(page).to have_selector("li.create_date", text: asset.create_date.strftime("%m/%d/%Y"))
      expect(page).to have_selector("li.modified_date", text: asset.modified_date.strftime("%m/%d/%Y"))
      expect(page).to have_selector("li.language", text: asset.language.first)
    end
  end
end
