# frozen_string_literal: true
require 'rails_helper'

describe AssetTypeVerificationService do
  subject { described_class.call(file, asset_type) }

  context "with a valid still image" do
    let(:file)       { double(original_filename: "good_image.tiff") }
    let(:asset_type) { AICType.StillImage }
    it { is_expected.to be true }
  end

  context "with an invalid still image" do
    let(:file)       { double(original_filename: "bad_image.txt") }
    let(:asset_type) { AICType.StillImage }
    it { is_expected.to be false }
  end

  context "with a valid text file" do
    let(:file)       { double(original_filename: "good_text.txt") }
    let(:asset_type) { AICType.Text }
    it { is_expected.to be true }
  end

  context "with an invalid text file" do
    let(:file)       { double(original_filename: "bad_text.gif") }
    let(:asset_type) { AICType.Text }
    it { is_expected.to be false }
  end
end
