require 'rails_helper'

describe ListPresenter do
  subject { described_class.new(List.where(pref_label: "Status").first) }

  describe "#to_s" do
    its(:to_s) { is_expected.to eq("Status") }
  end

  describe "#member_list" do
    let(:member_list) { described_class.new(List.where(pref_label: "Status").first).member_list }
    subject { member_list }
    it { is_expected.to include(Struct::ListItemPresenter) }
    context "when an item as no description" do
      before { allow_any_instance_of(ListItem).to receive(:description).and_return([]) }
      subject { member_list.first }
      its(:description) { is_expected.to eq("No description available") }
    end
    context "with StatusType.active" do
      subject { member_list.map { |m| m if m.id == StatusType.active.id }.compact.first }
      it { is_expected.not_to be_deletable }
    end
    context "with any other StatusType" do
      subject { member_list.map { |m| m if m.id != StatusType.active.id }.compact.first }
      it { is_expected.to be_deletable }
    end
  end
end
