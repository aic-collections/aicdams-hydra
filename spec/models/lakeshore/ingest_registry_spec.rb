# frozen_string_literal: true
require 'rails_helper'

describe Lakeshore::IngestRegistry do
  let(:user) { create(:user) }

  subject(:registry) { described_class.new(content, user) }

  describe "unique?" do
    context "without any content in the api request" do
      let(:content) { {} }
      it { is_expected.to be_unique }
    end

    context "with non-duplicate files" do
      let(:content) { { intermediate: "intermediate file", pres_master: "pres master file" } }
      before { allow(registry).to receive(:duplicates).and_return([]) }
      it { is_expected.to be_unique }
    end

    context "with one or more duplicate files in the registry" do
      let(:content) { { intermediate: "intermediate file", pres_master: "duplicate" } }
      before { allow(registry).to receive(:duplicates).and_return(["duplicate"]) }
      it { is_expected.not_to be_unique }
    end
  end

  describe "#intermediate_file" do
    context "without any content from the api request" do
      let(:content) { {} }
      its(:intermediate_file) { is_expected.to be_nil }
    end
  end

  describe "#files" do
    context "without any content in the api request" do
      let(:content) { {} }
      subject { registry }

      its(:files) { is_expected.to be_empty }
    end

    context "with both named and non-named file types in the api request" do
      let(:content) { { intermediate: "intermediate file", pres_master: "pres master file", other: "other file" } }

      it "is an array of ingest files" do
        expect(registry.files.count).to eq(3)
      end
    end

    context "with only named file types in the api request" do
      let(:content) { { intermediate: "intermediate file", pres_master: "pres master file" } }

      it "is an array of ingest files" do
        expect(registry.files.count).to eq(2)
      end
    end
  end
end
