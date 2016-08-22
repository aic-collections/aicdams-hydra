# frozen_string_literal: true
require 'rails_helper'

describe AssetSearchBuilder do
  let(:processor_chain) { [:filter_models] }
  let(:context) { double('context') }
  let(:acces_controls_query) { "({!terms f=edit_access_group_ssim}public,registered) OR ({!terms f=discover_access_group_ssim}public,registered) OR ({!terms f=read_access_group_ssim}public,registered) OR edit_access_person_ssim:user1 OR discover_access_person_ssim:user1 OR read_access_person_ssim:user1" }
  let(:solr_params) { { fq: [acces_controls_query] } }

  subject { described_class.new(processor_chain, context) }

  describe "#remove_discovery_permissions" do
    before { subject.filter_models(solr_params) }

    context "when discovery-related permsions exist" do
      let(:solr_params) { { fq: [acces_controls_query] } }

      it "deletes any discovery-related permissions from the solr parameters" do
        expect(solr_params[:fq].join(" ")).to include("discover_access_group_ssim", "discover_access_person_ssim")
        subject.remove_discovery_permissions(solr_params)
        expect(solr_params[:fq].join(" ")).not_to include("discover_access_group_ssim", "discover_access_person_ssim")
        expect(solr_params[:fq].join(" ")).to include("read_access_group_ssim", "read_access_person_ssim")
        expect(solr_params[:fq].join(" ")).to include("edit_access_group_ssim", "edit_access_person_ssim")
      end
    end

    context "when no discovery-related permsions exist" do
      let(:solr_params) { { fq: [] } }

      it "retains all existing queries" do
        expect(solr_params[:fq].join).to eq("{!terms f=has_model_ssim}GenericWork,Agent,Exhibition,Place,Shipment,Transaction,Work,Collection")
      end
    end

    context "with no fq" do
      let(:solr_params) { { q: ["search"] } }

      it "retains all existing parameters" do
        expect(solr_params).to eq(solr_params)
      end
    end
  end
end
