# frozen_string_literal: true
require 'rails_helper'

describe AICUserIndexer do
  describe "#generate_solr_document" do
    let(:solr_doc) { described_class.new(user).generate_solr_document }

    context "with an active user" do
      let(:user) { create(:active_user) }
      it "sets the field to true" do
        expect(solr_doc["status_bsi"]).to be true
      end
    end

    context "with an inactive user" do
      let(:user) { create(:inactive_user) }
      it "sets the field to false" do
        expect(solr_doc["status_bsi"]).to be false
      end
    end
  end
end
