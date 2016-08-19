# frozen_string_literal: true
require 'rails_helper'

describe GenericWork do
  let(:department_asset) { build(:department_asset) }
  let(:registered_asset) { build(:registered_asset) }

  describe "default permissions" do
    it { is_expected.not_to be_private }
    it { is_expected.to be_department }
    its(:discover_groups) { is_expected.to contain_exactly(Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_AUTHENTICATED) }
  end

  describe "visibility" do
    context "by default" do
      its(:visibility) { is_expected.to eq(Permissions::LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT) }
      its(:read_groups) { is_expected.to be_empty }
    end

    context "when setting to restricted" do
      before { subject.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE }
      specify { expect(subject.errors.messages[:visibility]).to include("cannot be restricted") }
    end

    context "when setting to open" do
      before { subject.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC }
      its(:read_groups) { is_expected.to include("public") }
    end

    context "when changing from department to registered" do
      subject { department_asset }
      before { department_asset.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED }
      its(:read_groups) { is_expected.to contain_exactly(Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_AUTHENTICATED) }
      its(:visibility) { is_expected.to eq(Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED) }
    end

    context "when changing from registered to department" do
      subject { registered_asset }
      before { registered_asset.visibility = Permissions::LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT }
      its(:read_groups) { is_expected.to contain_exactly(Permissions::LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT, "100") }
      its(:visibility) { is_expected.to eq(Permissions::LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT) }
    end
  end

  describe "#apply_depositor_metadata" do
    context "with an AIC depositor" do
      subject { registered_asset }
      its(:depositor) { is_expected.to eq("user1") }
      its(:aic_depositor) { is_expected.to be_kind_of(AICUser) }
      its(:dept_created) { is_expected.to be_kind_of(Department) }
      describe "#to_solr" do
        subject { registered_asset.to_solr }
        it { is_expected.to include("aic_depositor_ssim" => "user1") }
      end
    end

    context "without an AIC depositor" do
      subject { build(:asset, user: "nobody") }
      its(:save) { is_expected.to be false }
    end
  end
end
