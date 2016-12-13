# frozen_string_literal: true
require 'rails_helper'

describe DeleteIndexJob do
  let(:id)  { "1234" }
  let(:job) { described_class }

  context "when a record exists in Solr but not in Fedora" do
    before { allow(ActiveFedora::Base).to receive(:exists?).with(id).and_return(false) }
    it "removes the record from Solr" do
      expect(ActiveFedora::SolrService.instance.conn).to receive(:delete_by_id).with(id, params: { softCommit: false })
      job.perform_now(id)
    end
  end

  context "when a record exists in Solr as well as Fedora" do
    before { allow(ActiveFedora::Base).to receive(:exists?).with(id).and_return(true) }
    it "removes the record from Solr" do
      expect(ActiveFedora::SolrService.instance.conn).not_to receive(:delete_by_id)
      job.perform_now(id)
    end
  end
end
