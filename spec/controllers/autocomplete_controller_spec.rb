# frozen_string_literal: true
require 'rails_helper'

describe AutocompleteController do
  describe "#index" do
    let!(:asset) { create(:asset, pref_label: "Autocomplete example") }

    before  { get :index, q: query, format: :json }
    subject { JSON.parse(response.body).first }

    context "with no results" do
      let(:query) { "Bogus stuff" }
      it { is_expected.to be_nil }
    end

    context "with a partial label query" do
      let(:query) { "complete" }
      it { is_expected.to include("prefLabel" => ["Autocomplete example"]) }
    end

    context "with a complete label query" do
      let(:query) { "Autocomplete example" }
      it { is_expected.to include("prefLabel" => ["Autocomplete example"]) }
    end

    context "with a partial UID query" do
      let(:query) { asset.id.first(4) }
      it { is_expected.to include("prefLabel" => ["Autocomplete example"]) }
    end
  end
end
