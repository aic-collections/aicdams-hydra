# frozen_string_literal: true
require 'rails_helper'

describe "Editing CITI work" do
  let(:user)  { create(:user1) }
  let(:asset) { create(:asset, :with_intermediate_file_set, pref_label: "Representation of work") }
  let(:pref)  { create(:asset, pref_label: "Assigned preferred representation of work") }

  let(:notification) do
    stub_request(:post, "https://citiworker/").with(body: hash_including(citi_uid: work.citi_uid))
  end

  before do
    notification.to_return(status: 202)
    sign_in_with_named_js(:edit_work, user)
    visit(edit_polymorphic_path(work))
  end

  context "with a representation and no preferred representation" do
    let(:work) { create(:work, :with_sample_metadata, representations: [asset.uri]) }

    it "the preferred representation uri should be nil" do
      expect(work.preferred_representation_uri).to be_nil
    end

    it "there should be no star icon" do
      expect(page).not_to have_selector(".aic-star-on")
    end

    it "there should be one star-off icon" do
      expect(page).to have_selector(".aic-star-off", count: 1)
    end

    it "the hidden_preferred_representation.value should be an empty string" do
      expect(hidden_preferred_representation.value).to eq("")
    end

    it "after clicking save the preferred representation is set to the first representation" do
      click_button("Save")
      work.reload
      expect(work.preferred_representation_uri).to eq(asset.uri)
    end

    it "the work show page includes a preferred 'star' icon" do
      click_button("Save")
      expect(page).to have_selector(".aic-star-on", count: 1)
    end

    it "a CITI notification is made" do
      click_button("Save")
      expect(notification).to have_been_made
    end
  end

  context "when removing a pref_rep when other reps exist" do
    let(:work) do
      create(:work, :with_sample_metadata,
             representations: [pref.uri, asset.uri],
             preferred_representation_uri: pref.uri
            )
    end

    it "when page loads, pref_rep is pref.uri" do
      expect(hidden_preferred_representation.value).to eq(pref.uri)
    end
  end

  context "when loading a work with two reps, one preferred" do
    let(:work) do
      create(:work, :with_sample_metadata,
             representations: [asset.uri, pref.uri],
             preferred_representation_uri: pref.uri
            )
    end
    it "a hidden input is on the page with a URI of the preferred rep" do
      expect(hidden_preferred_representation.value).to eq(pref.uri)
    end
  end
end
