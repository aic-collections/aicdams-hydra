# frozen_string_literal: true
require 'rails_helper'

describe ApplicationHelper do
  describe "#env_title_prefix" do
    it "returns LCL: when local environment" do
      f = stub_const("Figaro::ENV", double)
      allow(f).to receive(:LAKESHORE_ENV) { "local" }
      expect(helper.env_title_prefix).to eq("LCL:")
    end
    it "returns DEV: when develop environment" do
      f = stub_const("Figaro::ENV", double)
      allow(f).to receive(:LAKESHORE_ENV) { "dev" }
      expect(helper.env_title_prefix).to eq("DEV:")
    end
    it "returns TST: when test environment" do
      f = stub_const("Figaro::ENV", double)
      allow(f).to receive(:LAKESHORE_ENV) { "test" }
      expect(helper.env_title_prefix).to eq("TST:")
    end
    it "returns STG: when staging environment" do
      f = stub_const("Figaro::ENV", double)
      allow(f).to receive(:LAKESHORE_ENV) { "staging" }
      expect(helper.env_title_prefix).to eq("STG:")
    end
    it "returns empty string when production environment" do
      f = stub_const("Figaro::ENV", double)
      allow(f).to receive(:LAKESHORE_ENV) { "production" }
      expect(helper.env_title_prefix).to eq("")
    end
    it "returns empty string if ENV var is not set" do
      f = stub_const("Figaro::ENV", double)
      allow(f).to receive(:LAKESHORE_ENV) { nil }
      expect(helper.env_title_prefix).to eq("")
    end
  end

  describe "#use_uri_options" do
    subject { helper.use_uri_options }

    context "when creating in batches" do
      it { is_expected.not_to include([AICType.IntermediateFileSet.label, AICType.IntermediateFileSet]) }
    end

    context "when creating a single asset" do
      before { allow(helper).to receive(:controller_name).and_return("generic_works") }
      it { is_expected.to include([AICType.IntermediateFileSet.label, AICType.IntermediateFileSet]) }
    end
  end

  describe "#citi_models" do
    subject { helper.citi_models }

    it { is_expected.to contain_exactly("Agent", "Exhibition", "Place", "Shipment", "Transaction", "Work") }
  end
end
