# frozen_string_literal: true
require 'rails_helper'

describe AssetTypeVerificationService do
  subject { described_class.call(file, asset_type) }

  context "with a valid still image" do
    let(:file)       { double(original_filename: "good.tiff") }
    let(:asset_type) { AICType.StillImage }
    it { is_expected.to be true }
  end

  context "with an invalid still image" do
    let(:file)       { double(original_filename: "bad.txt") }
    let(:asset_type) { AICType.StillImage }
    it { is_expected.to be false }
  end

  context "with a valid text file" do
    let(:file)       { double(original_filename: "good.txt") }
    let(:asset_type) { AICType.Text }
    it { is_expected.to be true }
  end

  context "with an invalid text file" do
    let(:file)       { double(original_filename: "bad.gif") }
    let(:asset_type) { AICType.Text }
    it { is_expected.to be false }
  end

  context "with a valid dataset" do
    let(:file)       { double(original_filename: "good.xml") }
    let(:asset_type) { AICType.Dataset }
    it { is_expected.to be true }
  end

  context "with an invalid dataset" do
    let(:file)       { double(original_filename: "bad.gif") }
    let(:asset_type) { AICType.Dataset }
    it { is_expected.to be false }
  end

  context "with a valid archive" do
    let(:file)       { double(original_filename: "good.zip") }
    let(:asset_type) { AICType.Archive }
    it { is_expected.to be true }
  end

  context "with an invalid archive" do
    let(:file)       { double(original_filename: "bad.gif") }
    let(:asset_type) { AICType.Archive }
    it { is_expected.to be false }
  end

  context "with a valid sound file" do
    let(:file)       { double(original_filename: "good.wav") }
    let(:asset_type) { AICType.Sound }
    it { is_expected.to be true }
  end

  context "with an invalid sound file" do
    let(:file)       { double(original_filename: "bad.gif") }
    let(:asset_type) { AICType.Sound }
    it { is_expected.to be false }
  end

  context "with a valid moving image" do
    let(:file)       { double(original_filename: "good.mp4") }
    let(:asset_type) { AICType.MovingImage }
    it { is_expected.to be true }
  end

  context "with an invalid moving image" do
    let(:file)       { double(original_filename: "bad.wav") }
    let(:asset_type) { AICType.MovingImage }
    it { is_expected.to be false }
  end
end
