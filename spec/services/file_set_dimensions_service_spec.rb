# frozen_string_literal: true
require 'rails_helper'

describe FileSetDimensionsService do
  let(:file_set) { build(:file_set, id: "12as34df") }
  let(:parent) { build(:still_image_asset) }

  before do
    allow(file_set).to receive(:parent).and_return(parent)
    allow(file_set).to receive(:mime_type).and_return(mime_type)
  end

  subject { described_class.new(file_set) }

  context 'with a file that has no dimensions' do
    let(:mime_type) { "text/plain" }

    before do
      allow(file_set).to receive(:height).and_return(nil)
      allow(file_set).to receive(:width).and_return(nil)
    end

    its(:height) { is_expected.to be_nil }
    its(:width) { is_expected.to be_nil }
  end

  context 'with a typical image' do
    let(:mime_type) { "image/png" }

    before do
      allow(file_set).to receive(:height).and_return(["800"])
      allow(file_set).to receive(:width).and_return(["600"])
    end

    its(:height) { is_expected.to eq(800) }
    its(:width) { is_expected.to eq(600) }
  end

  context 'with a pdf converted to a jp2', skip: LakeshoreTesting.continuous_integration? do
    let(:mime_type) { "application/pdf" }
    let(:jp2_path) { File.join(fixture_path, "test.jp2") }
    let(:mock_derivative_path) { double }

    before do
      allow(DerivativePath).to receive(:new).with(file_set).and_return(mock_derivative_path)
      allow(mock_derivative_path).to receive(:access_path).and_return(jp2_path)
    end

    its(:height) { is_expected.to eq(792) }
    its(:width) { is_expected.to eq(612) }
  end
end
