# frozen_string_literal: true
require 'rails_helper'

describe ListIndexer do
  let(:list) { build(:list) }

  describe "#generate_solr_document" do
    let(:solr_doc) { described_class.new(list).generate_solr_document }

    it "indexes RDF types" do
      expect(solr_doc["types_ssim"]).to contain_exactly(AICType.List, AICType.Resource)
    end
  end
end
