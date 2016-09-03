# frozen_string_literal: true
require 'rails_helper'

describe AutocompleteController do
  describe "#index" do
    context "when searching for assets" do
      let!(:asset) { create(:asset, pref_label: "Autocomplete example") }

      before  { get :index, q: query, format: :json }
      subject { JSON.parse(response.body).first }

      context "with no results" do
        let(:query) { "Bogus stuff" }
        subject { JSON.parse(response.body).first }
        it { is_expected.to be_nil }
      end

      context "with a partial label query" do
        let(:query) { "complete" }
        it { is_expected.to include("label" => "Autocomplete example", "id" => start_with("http")) }
      end

      context "with a complete label query" do
        let(:query) { "Autocomplete example" }
        it { is_expected.to include("label" => "Autocomplete example", "id" => start_with("http")) }
      end

      context "with a partial UID query" do
        let(:query) { asset.uid.last(4) }
        xit { is_expected.to include("label" => "Autocomplete example", "id" => start_with("http")) }
      end
    end

    context "when searching for Citi resources" do
      let!(:agent) { create(:agent, pref_label: "Agent to search") }

      before { get :index, q: query, model: "Agent", format: :json }
      subject { JSON.parse(response.body).first }

      context "with a partial label query" do
        let(:query) { "Age" }
        it { is_expected.to include("label" => "Agent to search", "id" => agent.id) }
      end
    end
  end
end
