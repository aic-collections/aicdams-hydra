# frozen_string_literal: true
require 'rails_helper'

describe AutocompleteController do
  render_views
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
        it { is_expected.to include("label" => "Autocomplete example", "id" => start_with("http")) }
      end
    end

    context "when searching for Citi resources" do
      subject { JSON.parse(response.body).first }

      context "with a partial label query" do
        let!(:agent) { create(:agent, pref_label: "Zzypdx Abc") }
        before { get :index, q: "pdx", model: "Agent", format: :json }
        it { is_expected.to include("label" => "Zzypdx Abc", "id" => agent.id) }
      end

      context "with a partial ref. number query" do
        let!(:work)  { create(:work, pref_label: "Work to search", main_ref_number: "1999.678") }
        before { get :index, q: "678", model: "Work", format: :json }
        it { is_expected.to include("label" => "Work to search", "main_ref_number" => work.main_ref_number) }
      end
    end
  end
end
