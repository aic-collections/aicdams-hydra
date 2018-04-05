# frozen_string_literal: true
require 'rails_helper'

describe InboundRelationshipManagementService do
  let(:user)     { nil }
  let(:service)  { described_class.new(resource, user) }
  let(:resource) { create(:asset) }
  let(:work)     { create(:non_asset) }

  before do
    Rails.application.routes.draw do
      namespace :curation_concerns, path: :concern do
        resources :non_assets
        mount Sufia::Engine => '/'
      end
    end
  end

  after do
    Rails.application.reload_routes!
  end

  subject { work }

  describe "#add_or_remove" do
    context "without pre-existing relationships" do
      context "with an id" do
        before do
          service.add_or_remove(:documents, [work.id])
          work.reload
        end

        its(:documents) { is_expected.to contain_exactly(resource) }
      end

      context "with a uri" do
        before do
          service.add_or_remove(:documents, [work.uri.to_s])
          work.reload
        end

        its(:documents) { is_expected.to contain_exactly(resource) }
      end
    end

    context "when replacing a relationship" do
      let!(:resource) { create(:asset) }
      let!(:old_work) { create(:non_asset, document_uris: [resource.uri]) }
      let!(:work)     { create(:non_asset) }

      it "removes the relationship from one work and adds it to the other" do
        expect(old_work.documents).to contain_exactly(resource)
        service.add_or_remove(:documents, [work.id])
        work.reload
        old_work.reload
        expect(work.documents).to contain_exactly(resource)
        expect(old_work.documents).to be_empty
      end
    end

    context "with preferred representations" do
      let(:resource) { "resource" }
      it "returns an error" do
        expect { service.add_or_remove(:preferred_representations, ["ids"]) }.to raise_error(NotImplementedError)
      end
    end
  end

  describe "#add_or_remove_representations" do
    context "without any representations" do
      let(:user)     { create(:user) }

      before do
        service.add_or_remove_representations([work.id])
        work.reload
      end

      it "sets both the representation and preferred representation" do
        expect(work.representations).to contain_exactly(resource)
        expect(work.preferred_representation).to eq(resource)
      end
    end

    context "when replacing a relationship" do
      let!(:user)     { create(:user) }
      let!(:resource) { create(:asset) }
      let!(:old_work) { create(:non_asset, representation_uris: [resource.uri]) }
      let!(:work)     { create(:non_asset) }

      it "removes relationships from one work and adds them to the other" do
        expect(old_work.representations).to contain_exactly(resource)
        service.add_or_remove_representations([work.id])
        work.reload
        old_work.reload
        expect(work.representations).to contain_exactly(resource)
        expect(work.preferred_representation).to eq(resource)
        expect(old_work.representations).to be_empty
      end
    end
  end

  describe "#update" do
    context "with a relationship other than preferred representations" do
      let(:resource) { "resource" }
      it "returns an error" do
        expect { service.update(:representations, ["ids"]) }.to raise_error(NotImplementedError)
      end
    end

    context "with preferred representations" do
      before do
        service.update(:preferred_representations, [work.id])
        work.reload
      end

      it "updates both preferred and normal representations" do
        expect(subject.preferred_representation).to eq(resource)
        expect(subject.representations).to contain_exactly(resource)
      end
    end
  end
end
