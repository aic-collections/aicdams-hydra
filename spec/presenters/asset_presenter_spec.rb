require 'rails_helper'

describe AssetPresenter do
  let(:presenter) { described_class.new(GenericFile.new) }

  describe "#terms" do
    subject { presenter.terms }
    it { is_expected.not_to include(:resource_type) }
    it { is_expected.to include(:title) }
  end

  # TODO: needs to show either representation, preferred representation, or document
  describe "#brief_terms" do
    subject { presenter.brief_terms }
    it { is_expected.to contain_exactly(:asset_type, :uid, :pref_label) }
  end

  describe "#asset_type" do
    context "with an image" do
      before { allow_any_instance_of(GenericFile).to receive(:still_image?).and_return(true) }
      subject { presenter.asset_type }
      it { is_expected.to eql("Image") }
    end
    context "with an text document" do
      before { allow_any_instance_of(GenericFile).to receive(:text?).and_return(true) }
      subject { presenter.asset_type }
      it { is_expected.to eql("Text Document") }
    end
  end

  describe "relationships" do
    subject { presenter }
    its(:documents) { is_expected.to be_empty }
    its(:representations) { is_expected.to be_empty }
    its(:preferred_representations) { is_expected.to be_empty }
    its(:assets) { is_expected.to be_empty }
    it { is_expected.not_to be_representing }
  end
end
