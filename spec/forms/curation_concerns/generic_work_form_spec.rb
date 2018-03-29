# frozen_string_literal: true
require 'rails_helper'

describe CurationConcerns::GenericWorkForm do
  let(:user1)   { create(:user1) }
  let(:asset)   { build(:asset, alt_label: ["A New Alternative"]) }
  let(:ability) { Ability.new(user1) }
  let(:form)    { described_class.new(asset, ability) }
  subject { form }

  describe "delegates" do
    it { is_expected.to delegate_method(:dept_created).to(:model) }
    it { is_expected.to delegate_method(:attachment_uris).to(:model) }
    it { is_expected.to delegate_method(:attachments).to(:model) }
    it { is_expected.to delegate_method(:copyright_representatives).to(:model) }
    it { is_expected.to delegate_method(:imaging_uid_placeholder).to(:model) }
  end

  describe "attr_writers" do
    it { is_expected.to respond_to(:action_name=) }
    it { is_expected.to respond_to(:action_name) }
    it { is_expected.to respond_to(:current_ability=) }
    it { is_expected.to respond_to(:current_ability) }
  end

  describe "::aic_terms" do
    it "includes :imaging_uid_placeholder" do
      expect(described_class.aic_terms).to include(:imaging_uid_placeholder)
    end
  end

  describe "#required_fields" do
    its(:required_fields) { is_expected.to contain_exactly(:asset_type, :document_type_uri) }
  end

  describe "#primary_terms" do
    its(:primary_terms) { is_expected.not_to include(:asset_type, :external_resources) }
  end

  describe "#secondary_terms" do
    its(:secondary_terms) { is_expected.to be_empty }
  end

  describe "#asset_type" do
    its(:asset_type) { is_expected.to eq(AICType.StillImage) }
  end

  describe "#use_uri" do
    its(:use_uri) { is_expected.to eq(AICType.IntermediateFileSet) }
  end

  context "A Form with Alt Label metadata" do
    describe "#alt_label" do
      its(:alt_label) { is_expected.to eq(["A New Alternative"]) }
    end
  end

  describe "::model_attributes" do
    subject { described_class.model_attributes(attributes) }
    context "with arrays of empty strings" do
      let(:attributes) { ActionController::Parameters.new(collection_ids: [""], document_type_uri: "") }
      it { is_expected.to eq("collection_ids" => [], "document_type_uri" => "") }
    end
  end

  describe "::build_permitted_params" do
    subject { described_class.build_permitted_params }
    it { is_expected.to include(:additional_representation,
                                :additional_document,
                                :uid,
                                :dept_created,
                                external_resources: []) }
  end

  describe "::multiple?" do
    subject { described_class.multiple?(:attachment_uris) }
    it { is_expected.to be true }
  end

  describe "#uris_for" do
    subject { form.uris_for(:keyword) }
    context "with no items" do
      it { is_expected.to be_empty }
    end
    context "with an array of RDF::URI items" do
      let(:term) { create(:list_item) }
      before { allow(asset).to receive(:keyword).and_return([term]) }
      it { is_expected.to eq([term.uri.to_s]) }
    end
  end

  describe "#uri_for" do
    subject { form.uri_for(:compositing) }
    context "with no items" do
      it { is_expected.to be_nil }
    end
    context "with a RDF::URI item" do
      let(:term) { create(:list_item) }
      before { allow(asset).to receive(:compositing).and_return(term) }
      it { is_expected.to eq(term.uri.to_s) }
    end
  end

  context "when the asset has a relationship to a CITI resource" do
    let!(:asset)    { create(:asset) }
    let!(:resource) { create(:exhibition, representations: [asset.uri], documents: [asset.uri]) }

    describe "#representations_for" do
      its(:representations_for) { is_expected.to contain_exactly(kind_of(SolrDocument)) }
    end

    describe "#documents_for" do
      its(:documents_for) { is_expected.to contain_exactly(kind_of(SolrDocument)) }
    end
  end

  context "when the asset has an attachment" do
    let!(:asset)    { create(:asset) }
    let!(:resource) { create(:asset, attachments: [asset.uri]) }

    describe "#attachments_for" do
      its(:attachments_for) { is_expected.to contain_exactly(kind_of(SolrDocument)) }
    end
  end

  describe "#disabled?" do
    context "when using :only" do
      subject { form.disabled?(:publish_channels) }
      it { is_expected.to be(true) }
    end

    context "without any restrictions" do
      subject { form.disabled?(:capture_device) }
      it { is_expected.to be(false) }
    end

    context "with an unlisted field" do
      subject { form.disabled?(:bogus) }
      it { is_expected.to be(false) }
    end

    context "with an admin user" do
      let(:user1) { create(:admin) }
      subject { form.disabled?(:publish_channels) }
      it { is_expected.to be(false) }
    end
  end
end
