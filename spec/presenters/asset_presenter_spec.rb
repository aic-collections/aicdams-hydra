# frozen_string_literal: true
require 'rails_helper'

describe AssetPresenter do
  let(:solr_document) { SolrDocument.new(attributes) }
  let(:request) { double }
  let(:date_value) { Date.today }
  let(:date_index) { date_value.to_s }
  let(:attributes) do
    { "pref_label_tesim" => "Sample Label",
      "human_readable_type_tesim" => ["Asset"],
      "has_model_ssim" => ["GenericWork"],
      "date_created_tesim" => ['an unformatted date'],
      "date_modified_dtsi" => date_index,
      "date_uploaded_dtsi" => date_index }
  end
  let(:ability) { nil }
  # You'll need this with the latest Sufia
  # let(:presenter) { described_class.new(solr_document, ability, request) }
  let(:presenter) { described_class.new(solr_document, ability) }

  subject { presenter }

  it { is_expected.to delegate_method(:uid).to(:solr_document) }
  it { is_expected.to delegate_method(:legacy_uid).to(:solr_document) }
  it { is_expected.to delegate_method(:document_type).to(:solr_document) }
  it { is_expected.to delegate_method(:status).to(:solr_document) }
  it { is_expected.to delegate_method(:created).to(:solr_document) }
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

  its(:title) { is_expected.to eq(["Sample Label"]) }

  its(:permission_badge_class) { is_expected.to eq(PermissionBadge) }
  its(:file_presenter_class)   { is_expected.to eq(FileSetPresenter) }

  describe "#has_relationships?" do
    it { is_expected.not_to have_relationships }
  end

  describe "#is_citi_presenter?" do
    it { is_expected.not_to be_citi_presenter }
  end
end
