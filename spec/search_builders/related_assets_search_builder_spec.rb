# frozen_string_literal: true
require 'rails_helper'

describe RelatedAssetsSearchBuilder do
  let(:processor_chain) { [] }
  let(:context) { double }
  let(:builder) { described_class.new(processor_chain, context) }

  before do
    allow(builder).to receive(:blacklight_params).and_return(blacklight_params)
  end

  describe "#show_related_assets" do
    subject { builder.show_related_assets({}) }

    context "with multiple resource ids" do
      let(:blacklight_params) { { relationship_type: "hasDocumentation", resource_id: "43523, 1234", model: "Work" } }
      it { is_expected.to eq("{!join from=documents_ssim to=id}citi_uid_ssim:(43523 OR 1234) AND has_model_ssim:Work") }
    end

    context "with one resource id" do
      let(:blacklight_params) { { relationship_type: "hasDocumentation", resource_id: "43523", model: "Work" } }
      it { is_expected.to eq("{!join from=documents_ssim to=id}citi_uid_ssim:43523 AND has_model_ssim:Work") }
    end

    context "with no resource ids" do
      let(:blacklight_params) { { relationship_type: "hasDocumentation", resource_id: "", model: "Work" } }
      it { is_expected.to eq("{!join from=documents_ssim to=id}citi_uid_ssim:* AND has_model_ssim:Work") }
    end

    context "with representations" do
      let(:blacklight_params) { { relationship_type: "hasRepresentation", resource_id: "", model: "Work" } }
      it { is_expected.to eq("{!join from=representations_ssim to=id}citi_uid_ssim:* AND has_model_ssim:Work") }
    end

    context "with a preferred representation" do
      let(:blacklight_params) { { relationship_type: "hasPreferredRepresentation", resource_id: "", model: "Work" } }
      it { is_expected.to eq("{!join from=preferred_representation_ssim to=id}citi_uid_ssim:* AND has_model_ssim:Work") }
    end
  end
end
