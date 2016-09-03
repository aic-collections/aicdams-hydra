# frozen_string_literal: true
require 'rails_helper'

describe SolrDocument do
  describe "methods from Permissions::Readable" do
    context "by default" do
      its(:public?) { is_expected.to be false }
      its(:private?) { is_expected.to be false }
      its(:department?) { is_expected.to be true }
    end
    context "when registered" do
      before { subject["read_access_group_ssim"] = ["registered"] }
      its(:department?) { is_expected.to be false }
      its(:registered?) { is_expected.to be true }
    end
  end

  describe "#visibility" do
    subject { described_class.new(asset.to_solr).visibility }
    context "with department assets" do
      let(:asset) { build(:department_asset) }
      it { is_expected.to eq("department") }
    end
    context "with registered assets" do
      let(:asset) { build(:registered_asset) }
      it { is_expected.to eq("authenticated") }
    end
    context "by default" do
      let(:asset) { build(:asset) }
      it { is_expected.to eq("department") }
    end
  end

  describe "#title_or_label" do
    before { subject[Solrizer.solr_name("pref_label", :stored_searchable)] = "Title or label" }
    its(:title_or_label) { is_expected.to eq("Title or label") }
  end

  describe "#hydra_model" do
    let(:asset) { build(:department_asset) }
    subject { described_class.new(asset.to_solr) }
    its(:hydra_model) { is_expected.to eq(GenericWork) }
  end

  it { is_expected.to respond_to(:citi_uid) }
  it { is_expected.to respond_to(:status) }
  it { is_expected.to respond_to(:fedora_uri) }
  it { is_expected.to respond_to(:document_ids) }
  it { is_expected.to respond_to(:representation_ids) }
  it { is_expected.to respond_to(:preferred_representation_id) }
  it { is_expected.to respond_to(:aic_depositor) }
  it { is_expected.to respond_to(:dept_created) }
  it { is_expected.to respond_to(:thumbnail_path) }

  describe "Agent terms" do
    it { is_expected.to respond_to(:birth_year) }
    it { is_expected.to respond_to(:birth_date) }
    it { is_expected.to respond_to(:death_year) }
    it { is_expected.to respond_to(:death_date) }
  end

  describe "Work terms" do
    it { is_expected.to respond_to(:artist) }
    it { is_expected.to respond_to(:creator_display) }
    it { is_expected.to respond_to(:credit_line) }
    it { is_expected.to respond_to(:date_display) }
    it { is_expected.to respond_to(:department) }
    it { is_expected.to respond_to(:dimensions_display) }
    it { is_expected.to respond_to(:earliest_year) }
    it { is_expected.to respond_to(:exhibition_history) }
    it { is_expected.to respond_to(:gallery_location) }
    it { is_expected.to respond_to(:inscriptions) }
    it { is_expected.to respond_to(:latest_year) }
    it { is_expected.to respond_to(:main_ref_number) }
    it { is_expected.to respond_to(:medium_display) }
    it { is_expected.to respond_to(:object_type) }
    it { is_expected.to respond_to(:place_of_origin) }
    it { is_expected.to respond_to(:provenance_text) }
    it { is_expected.to respond_to(:publication_history) }
    it { is_expected.to respond_to(:publ_ver_level) }
  end

  describe "Exhibition terms" do
    it { is_expected.to respond_to(:start_date) }
    it { is_expected.to respond_to(:end_date) }
    it { is_expected.to respond_to(:name_official) }
    it { is_expected.to respond_to(:name_working) }
    it { is_expected.to respond_to(:exhibition_type) }
  end

  describe "Place terms" do
    it { is_expected.to respond_to(:lat) }
    it { is_expected.to respond_to(:long) }
  end

  describe "Asset terms" do
    it { is_expected.to respond_to(:capture_device) }
    it { is_expected.to respond_to(:digitization_source) }
    it { is_expected.to respond_to(:document_types) }
    it { is_expected.to respond_to(:legacy_uid) }
    it { is_expected.to respond_to(:keyword) }
    it { is_expected.to respond_to(:compositing) }
    it { is_expected.to respond_to(:imaging_uid) }
    it { is_expected.to respond_to(:light_type) }
    it { is_expected.to respond_to(:view) }
    it { is_expected.to respond_to(:transcript) }
  end

  describe "Resource terms" do
    it { is_expected.to respond_to(:batch_uid) }
    it { is_expected.to respond_to(:contributors) }
    it { is_expected.to respond_to(:created_by) }
    it { is_expected.to respond_to(:uid) }
    it { is_expected.to respond_to(:language) }
    it { is_expected.to respond_to(:publisher) }
    it { is_expected.to respond_to(:rights) }
    it { is_expected.to respond_to(:rights_statement) }
    it { is_expected.to respond_to(:rights_holder) }
    it { is_expected.to respond_to(:alt_label) }
  end
end
