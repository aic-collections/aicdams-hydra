# frozen_string_literal: true
require 'rails_helper'

describe CitiNotification do
  subject { described_class.new(file_set, resource) }

  context "without a file set" do
    let(:json) do
      {
        uid: ENV.fetch("citi_api_uid"),
        password: ENV.fetch("citi_api_password"),
        citi_uid: "WO-fake",
        type: "Work",
        lake_image_uid: nil,
        last_modified: nil,
        asset_details: { image_number: nil }
      }
    end

    describe "a notification with a AF:Base object" do
      let(:resource) { build(:work, id: "fakeid", citi_uid: "WO-fake") }
      let(:file_set) { nil }

      its(:to_json) { is_expected.to include_json(json) }
      its(:to_s) { is_expected.to include("********") }
    end

    describe "a notification with a SolrDocument" do
      let(:resource) { SolrDocument.new(build(:work, id: "fakeid", citi_uid: "WO-fake").to_solr) }
      let(:file_set) { nil }

      its(:to_json) { is_expected.to include_json(json) }
      its(:to_s) { is_expected.to include("********") }
    end
  end

  context "with a file set and citi resource" do
    let(:json) do
      {
        uid: ENV.fetch("citi_api_uid"),
        password: ENV.fetch("citi_api_password"),
        citi_uid: "WO-fake",
        type: "Work",
        lake_image_uid: "fakefsid",
        last_modified: "2017-07-14T00:00:00+00:00",
        asset_details: { image_number: nil }
      }
    end

    describe "a notification with a AF:Base object" do
      let(:resource)  { build(:work, id: "fakeid", citi_uid: "WO-fake") }
      let(:file_set)  { build(:file_set, id: "fakefsid") }
      let(:mock_file) { double("MockFile", fcrepo_modified: [DateTime.parse("July 14, 2017")]) }

      before { allow(file_set).to receive(:original_file).and_return(mock_file) }

      its(:to_json) { is_expected.to include_json(json) }
    end

    describe "a notification with a SolrDocument" do
      let(:resource)  { SolrDocument.new(build(:work, id: "fakeid", citi_uid: "WO-fake").to_solr) }
      let(:file_set)  { build(:file_set, id: "fakefsid") }
      let(:mock_file) { double("MockFile", fcrepo_modified: [DateTime.parse("July 14, 2017")]) }

      before { allow(file_set).to receive(:original_file).and_return(mock_file) }

      its(:to_json) { is_expected.to match(/fakefsid/) }
    end
  end

  context "with an imaging uid" do
    let(:json) do
      {
        uid: ENV.fetch("citi_api_uid"),
        password: ENV.fetch("citi_api_password"),
        citi_uid: "WO-fake",
        type: "Work",
        lake_image_uid: "fakefsid",
        last_modified: "2017-07-14T00:00:00+00:00",
        asset_details: { image_number: "1234" }
      }
    end

    describe "a notification with a AF:Base object" do
      let(:resource)  { build(:work, id: "fakeid", citi_uid: "WO-fake") }
      let(:file_set)  { build(:file_set, id: "fakefsid") }
      let(:parent)    { build(:asset, imaging_uid: ["1234"]) }
      let(:mock_file) { double("MockFile", fcrepo_modified: [DateTime.parse("July 14, 2017")]) }

      before do
        allow(file_set).to receive(:original_file).and_return(mock_file)
        allow(file_set).to receive(:parent).and_return(parent)
      end

      its(:to_json) { is_expected.to include_json(json) }
    end
  end
end
