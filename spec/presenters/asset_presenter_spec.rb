# frozen_string_literal: true
require 'rails_helper'

describe AssetPresenter do
  let(:asset)         { build(:department_asset, id: "1234", pref_label: "Sample Label") }
  let(:solr_document) { SolrDocument.new(asset.to_solr) }
  let(:ability)       { Ability.new(nil) }
  let(:presenter)     { described_class.new(solr_document, ability) }

  subject { presenter }

  it { is_expected.to delegate_method(:uid).to(:solr_document) }
  it { is_expected.to delegate_method(:legacy_uid).to(:solr_document) }
  it { is_expected.to delegate_method(:document_types).to(:solr_document) }
  it { is_expected.to delegate_method(:status).to(:solr_document) }
  it { is_expected.to delegate_method(:dept_created).to(:solr_document) }
  it { is_expected.to delegate_method(:updated).to(:solr_document) }
  it { is_expected.to delegate_method(:description).to(:solr_document) }
  it { is_expected.to delegate_method(:batch_uid).to(:solr_document) }
  it { is_expected.to delegate_method(:language).to(:solr_document) }
  it { is_expected.to delegate_method(:publisher).to(:solr_document) }
  it { is_expected.to delegate_method(:pref_label).to(:solr_document) }
  it { is_expected.to delegate_method(:rights_holder).to(:solr_document) }
  it { is_expected.to delegate_method(:keyword).to(:solr_document) }
  it { is_expected.to delegate_method(:created_by).to(:solr_document) }
  it { is_expected.to delegate_method(:compositing).to(:solr_document) }
  it { is_expected.to delegate_method(:light_type).to(:solr_document) }
  it { is_expected.to delegate_method(:view).to(:solr_document) }
  it { is_expected.to delegate_method(:capture_device).to(:solr_document) }
  it { is_expected.to delegate_method(:digitization_source).to(:solr_document) }
  it { is_expected.to delegate_method(:publish_channels).to(:solr_document) }
  it { is_expected.to delegate_method(:imaging_uid).to(:solr_document) }
  it { is_expected.to delegate_method(:view_notes).to(:solr_document) }
  it { is_expected.to delegate_method(:visual_surrogate).to(:solr_document) }
  it { is_expected.to delegate_method(:external_resources).to(:solr_document) }
  it { is_expected.to delegate_method(:licensing_restrictions).to(:solr_document) }
  it { is_expected.to delegate_method(:public_domain?).to(:solr_document) }
  it { is_expected.to delegate_method(:publishable?).to(:solr_document) }
  it { is_expected.to delegate_method(:copyright_representatives).to(:solr_document) }
  it { is_expected.to delegate_method(:related_image_id).to(:solr_document) }

  its(:title) { is_expected.to eq(["Sample Label"]) }

  its(:permission_badge_class) { is_expected.to eq(PermissionBadge) }
  its(:file_presenter_class)   { is_expected.to eq(FileSetPresenter) }

  describe "#has_relationships?" do
    it { is_expected.not_to have_relationships }
  end

  describe "#is_citi_presenter?" do
    it { is_expected.not_to be_citi_presenter }
  end

  describe "#artist_presenters?" do
    it { is_expected.not_to be_artist_presenters }
  end

  describe "#current_location_presenters?" do
    it { is_expected.not_to be_current_location_presenters }
  end

  describe "#manifest_url" do
    let(:request) { double(base_url: 'http://test.host') }

    let(:presenter) { described_class.new(solr_document, ability, request) }

    subject { presenter.manifest_url }

    it { is_expected.to eq 'http://test.host/concern/generic_works/1234/manifest' }
  end

  describe "#fedora_uri" do
    subject { presenter.fedora_uri }

    context "when the user is an admin" do
      before { allow(ability).to receive(:admin?).and_return(true) }
      it { is_expected.to end_with("/12/34/1234") }
    end

    context "when the user is not an admin" do
      before { allow(ability).to receive(:admin?).and_return(false) }
      it { is_expected.to be_nil }
    end
  end

  describe "#public_domain" do
    context "by default" do
      its(:public_domain) { is_expected.to eq("No") }
    end

    context "when true" do
      before { allow(solr_document).to receive(:public_domain?).and_return(true) }
      its(:public_domain) { is_expected.to eq("Yes") }
    end
  end

  describe "#publishable" do
    context "when false" do
      before { allow(solr_document).to receive(:publishable?).and_return(false) }
      its(:publishable) { is_expected.to eq("No") }
    end

    context "when true" do
      before { allow(solr_document).to receive(:publishable?).and_return(true) }
      its(:publishable) { is_expected.to eq("Yes") }
    end
  end

  describe "#viewable?" do
    context "when the user can view the asset" do
      let(:user)    { create(:user1) }
      let(:ability) { Ability.new(user) }
      it { is_expected.to be_viewable }
    end

    context "when the user cannot view the asset" do
      it { is_expected.not_to be_viewable }
    end

    context "when other dept user, cannot view the asset" do
      let(:user)    { create(:user2) }
      let(:ability) { Ability.new(user) }
      it { is_expected.not_to be_viewable }
    end
  end

  context "with a still image asset" do
    it { is_expected.to be_still_image }
    it { is_expected.not_to be_text }
  end

  context "with a text asset" do
    let(:asset) { build(:text_asset, id: "1234", pref_label: "Sample Label") }
    it { is_expected.to be_text }
    it { is_expected.not_to be_still_image }
  end
end
