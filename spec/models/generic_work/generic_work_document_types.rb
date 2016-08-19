# frozen_string_literal: true
require 'rails_helper'

describe GenericWork do
  let(:asset) { build(:asset) }
  let(:uri)   { "http://definitions.artic.edu/doctypes/DesignFile" }

  subject { asset }

  context "when the document is a uri" do
    before do
      asset.document_type_uri = uri
      asset.save
      asset.reload
    end

    its(:document_type_uri) { is_expected.to eq(uri) }
    its(:to_solr) { is_expected.to include("document_type_ssim" => uri) }
  end
end
