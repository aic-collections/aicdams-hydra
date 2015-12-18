require 'rails_helper'

describe ListItemEditForm do
  subject { described_class.new(ListItem.new) }

  its(:terms) { is_expected.to contain_exactly(:pref_label, :description) }

  describe "#model_attributes" do
    let(:list_item) { { "pref_label" => "New Thing", "description" => ["Description of new thing."] } }
    let(:params) { ActionController::Parameters.new(list_item) }
    specify do
      expect(described_class.model_attributes(params)).to eq(list_item)
    end
  end

  describe "#editable?" do
    context "when label can be edited" do
      subject { described_class.new(ListItem.new).editable?(:pref_label) }
      it { is_expected.to be true }
    end
    context "when the label can not be edited" do
      subject { described_class.new(StatusType.active).editable?(:pref_label) }
      it { is_expected.to be false }
    end
  end
end
