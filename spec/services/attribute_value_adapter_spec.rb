# frozen_string_literal: true
require 'rails_helper'

describe AttributeValueAdapter do
  subject { described_class.call(value, attribute_name) }

  let(:list_item) { create(:list_item) }
  let(:uri)       { "http://something/term" }
  let(:asset)     { create(:asset) }

  context "when no value is present" do
    let(:value) { nil }
    let(:attribute_name) { "something" }
    it { is_expected.to be_nil }
  end

  context "when the id is nil" do
    let(:value) { {} }
    let(:attribute_name) { "something" }
    it { is_expected.to be_nil }
  end

  context "when there is no specified class mapping" do
    let(:value) { { "id" => "1234" } }
    let(:attribute_name) { "missing_class" }
    it { is_expected.to be_nil }
  end

  context "with a digitization_source" do
    let(:value) { { "id" => list_item.id } }
    let(:attribute_name) { "digitization_source" }
    it { is_expected.to be_kind_of(ListItem) }
  end

  context "with a document_type" do
    let(:value) { { "id" => uri } }
    let(:attribute_name) { "document_type" }
    it { is_expected.to be_kind_of(Definition) }
  end

  context "with a first_document_sub_type" do
    let(:value) { { "id" => uri } }
    let(:attribute_name) { "first_document_sub_type" }
    it { is_expected.to be_kind_of(Definition) }
  end

  context "with a second_document_sub_type" do
    let(:value) { { "id" => uri } }
    let(:attribute_name) { "second_document_sub_type" }
    it { is_expected.to be_kind_of(Definition) }
  end

  context "with a tag" do
    let(:value) { { "id" => list_item.id } }
    let(:attribute_name) { "tag" }
    it { is_expected.to be_kind_of(ListItem) }
  end

  context "with a aic_depositor" do
    let(:value) { { "id" => AICUser.all.first.id } }
    let(:attribute_name) { "aic_depositor" }
    it { is_expected.to be_kind_of(AICUser) }
  end

  context "with a dept_created" do
    let(:value) { { "id" => Department.all.first.id } }
    let(:attribute_name) { "dept_created" }
    it { is_expected.to be_kind_of(Department) }
  end

  context "with a preferred_representation" do
    let(:value) { { "id" => asset.id } }
    let(:attribute_name) { "preferred_representation" }
    it { is_expected.to be_kind_of(GenericWork) }
  end
end
