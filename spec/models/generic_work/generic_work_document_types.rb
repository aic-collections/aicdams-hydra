# frozen_string_literal: true
require 'rails_helper'

describe GenericWork do
  let(:asset) { build(:asset) }
  let(:uri)   { "http://definitions.artic.edu/doctypes/DesignFile" }

  before do
    asset.document_type_uri = uri
    asset.save
  end

  subject { asset }

  context "when the document is a uri" do
    before { asset.reload }

    its(:document_type_uri) { is_expected.to eq(uri) }

    # TODO: this has never been the case. Is it still needed?
    # its(:to_solr) { is_expected.to include("document_type_ssim" => uri) }
  end

  describe "removing a value" do
    context "when setting to nil" do
      before do
        asset.document_type = nil
        asset.save
      end

      its(:document_type_uri) { is_expected.to be_nil }
    end

    context "when setting to an empty array" do
      before do
        asset.document_type = []
        asset.save
      end

      its(:document_type_uri) { is_expected.to be_nil }
    end

    context "when setting to an empty string" do
      before do
        asset.document_type_uri = ""
        asset.save
      end

      its(:document_type_uri) { is_expected.to be_nil }
    end
  end
end
