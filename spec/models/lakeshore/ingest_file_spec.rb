# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Lakeshore::IngestFile do
  let(:user) { create(:user) }
  let(:type) { :original }

  let(:file) do
    ActionDispatch::Http::UploadedFile.new(filename:     "sun.png",
                                           content_type: "image/png",
                                           tempfile:     File.new(File.join(fixture_path, "sun.png")))
  end

  subject { described_class.new(file: file, user: user, type: type, batch_id: UploadedBatch.create.id) }

  it { is_expected.to delegate_method(:original_filename).to(:file) }
  it { is_expected.to delegate_method(:errors).to(:uploaded_file) }

  describe "::types" do
    subject { described_class }
    its(:types) { is_expected.to contain_exactly(:original, :intermediate, :pres_master, :legacy) }
  end

  describe "#uploaded_file" do
    its(:uploaded_file) { is_expected.to be_a(Sufia::UploadedFile) }
  end

  describe "#uri" do
    context "with an original file" do
      its(:uri) { is_expected.to eq(AICType.OriginalFileSet) }
    end

    context "with an intermediate file" do
      let(:type) { :intermediate }
      its(:uri) { is_expected.to eq(AICType.IntermediateFileSet) }
    end

    context "with a preservation master file" do
      let(:type) { :pres_master }
      its(:uri) { is_expected.to eq(AICType.PreservationMasterFileSet) }
    end

    context "with a legacy file" do
      let(:type) { :legacy }
      its(:uri) { is_expected.to eq(AICType.LegacyFileSet) }
    end

    context "without a file type" do
      let(:type) { nil }
      its(:uri) { is_expected.to be_nil }
    end

    context "with an unregistered file" do
      let(:type) { :unregistered }
      it "raises an error" do
        expect {
          described_class.new(file: file, user: user, type: :unregistered, batch_id: UploadedBatch.create.id)
        }.to raise_error(Lakeshore::IngestFile::UnsupportedFileSetTypeError,
                         "'unregistered' is not a supported file set type")
      end
    end
  end

  describe "#duplicate? and #unique?" do
    context "with a unique file" do
      it { is_expected.not_to be_duplicate }
      it { is_expected.to be_unique }
    end

    context "with a duplicate file" do
      before { allow(subject).to receive(:errors).and_return(checksum: "error") }

      it { is_expected.to be_duplicate }
      it { is_expected.not_to be_unique }
    end
  end
end
