# frozen_string_literal: true
require 'rails_helper'

describe List do
  describe "::indexer" do
    subject { described_class }
    its(:indexer) { is_expected.to eq(ListIndexer) }
  end

  describe "::with_type" do
    context "with the existing status list" do
      subject { described_class.with_type(AICType.StatusTypeList) }
      it { is_expected.to be_kind_of(described_class) }
    end

    context "with a non-existent list" do
      subject { described_class.with_type("http://not.here/item") }
      it { is_expected.to be_nil }
    end
  end

  describe "::options" do
    context "with the existing status list" do
      subject { described_class.options(AICType.StatusTypeList) }
      its(:keys) { is_expected.to contain_exactly("Active", "Archived", "Deleted", "Disabled", "Invalid") }
      its(:values) { is_expected.to include(kind_of(RDF::URI)) }
    end
  end

  describe "#options" do
    context "with the existing status list" do
      subject { described_class.with_type(AICType.StatusTypeList).options }
      its(:keys) { is_expected.to contain_exactly("Active", "Archived", "Deleted", "Disabled", "Invalid") }
      its(:values) { is_expected.to include(kind_of(RDF::URI)) }
    end
  end

  context "when retrieving a list via RDF type" do
    before do
      list = described_class.new.tap do |l|
        l.pref_label = "Bogus list"
        l.type << RDF::URI("http://bogus.uri/type")
      end
      list.save
    end
    subject { described_class.where(types_ssim: "http://bogus.uri/type").first }
    its(:pref_label) { is_expected.to eq("Bogus list") }
  end

  context "when creating duplicated items in a new list" do
    let(:list) { create(:list) }
    before do
      list.add_item(ListItem.new(pref_label: "Used"))
      list.add_item(ListItem.new(pref_label: "Used"))
    end
    it "does not add the duplicate member" do
      expect(list.errors.full_messages).to contain_exactly("Members must be unique")
      expect(list.members.map(&:pref_label)).to contain_exactly("Used", "Item 1")
    end
  end

  describe "permissions" do
    subject { described_class.new }
    it { is_expected.to respond_to(:edit_users) }
    it { is_expected.to respond_to(:read_users) }
    it { is_expected.to respond_to(:edit_groups) }
    it { is_expected.to respond_to(:read_groups) }
  end
end
