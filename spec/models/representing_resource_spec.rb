# frozen_string_literal: true
require 'rails_helper'

describe RepresentingResource do
  let(:example_file) { build(:asset) }

  context "with an asset that is not any kind of representation" do
    subject { described_class.new(example_file.id) }
    it { is_expected.not_to be_representing }
  end

  context "with a nil id" do
    subject { described_class.new(nil) }
    its(:documents) { is_expected.to be_empty }
    its(:representations) { is_expected.to be_empty }
    its(:preferred_representation) { is_expected.to be_nil }
  end

  context "with an asset object" do
    subject { described_class.new(example_file) }
    it { is_expected.not_to be_representing }
  end
end
