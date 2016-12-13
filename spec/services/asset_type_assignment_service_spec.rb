# frozen_string_literal: true
require 'rails_helper'

describe AssetTypeAssignmentService do
  let(:asset)   { GenericWork.new }
  let(:service) { described_class.new(asset) }

  describe AssetTypeAssignmentService::REGISTRY do
    it { is_expected.to eq(AICType.StillImage => "SI",
                           AICType.Text => "TX",
                           AICType.Dataset => "DS",
                           AICType.MovingImage => "MI",
                           AICType.Sound => "SN",
                           AICType.Archive => "AR")}
  end

  describe "#assign" do
    subject { asset }

    context "with a valid asset type" do
      before { service.assign(AICType.StillImage) }
      its(:type) { is_expected.to include(AICType.StillImage) }
    end

    context "with an invalid asset type" do
      it "raises an error" do
        expect { service.assign(AICType.ListItem) }.to raise_error(ArgumentError, "invalid asset type")
      end
    end

    context "when the asset already has a type" do
      before { service.assign(AICType.StillImage) }
      it "raises an error" do
        expect { service.assign(AICType.Text) }.to raise_error(StandardError, "asset already has a type")
      end
    end
  end

  describe "#prefix" do
    subject { service }

    context "when the asset has a type" do
      before { service.assign(AICType.StillImage) }
      its(:prefix) { is_expected.to eq("SI") }
    end

    context "when the asset has a type" do
      its(:prefix) { is_expected.to be_nil }
    end
  end
end
