# frozen_string_literal: true
require 'rails_helper'

describe ListPresenter do
  let(:list) { create(:list, pref_label: "Sample List") }
  let(:presenter) { described_class.new(list) }

  describe "#to_s" do
    subject { presenter }
    its(:to_s) { is_expected.to eq("Sample List") }
    its(:description) { is_expected.to eq("No description available") }
  end

  describe "#member_list" do
    let(:member_list) { presenter.member_list }
    subject { member_list }
    it { is_expected.to include(ListPresenter::ListItemPresenter) }
  end

  describe ListPresenter::ListItemPresenter do
    let(:item) { create(:list_item, pref_label: "Sample List Item") }
    let(:presenter) { described_class.new(item) }

    describe "#to_s" do
      subject { presenter }
      its(:to_s) { is_expected.to eq("Sample List Item") }
      its(:description) { is_expected.to eq("No description available") }
    end

    describe "deletable?" do
      subject { presenter }
      context "when the item is not the active status" do
        it { is_expected.to be_deletable }
      end
      context "when the item is the active status" do
        before { allow(subject).to receive(:model).and_return(ListItem.active_status) }
        it { is_expected.not_to be_deletable }
      end
    end
  end
end
