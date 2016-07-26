# frozen_string_literal: true
shared_examples "a citi presenter" do
  it { is_expected.to delegate_method(:uid).to(:solr_document) }
  it { is_expected.not_to be_deleteable }
  its(:id) { is_expected.to eq('1234') }
  it { is_expected.to be_citi_presenter }
end

shared_examples "a citi presenter with related assets" do
  describe "#document_presenters" do
    before do
      allow(solr_doc).to receive(:document_ids).and_return(["asset-id"])
      allow(CurationConcerns::PresenterFactory).to receive(:build_presenters).with(
        ["asset-id"], AssetPresenter, ability, nil).and_return([asset_presenter])
    end
    its(:document_presenters) { is_expected.to contain_exactly(asset_presenter) }
  end

  describe "#representation_presenters" do
    before do
      allow(solr_doc).to receive(:representation_ids).and_return(["asset-id"])
      allow(CurationConcerns::PresenterFactory).to receive(:build_presenters).with(
        ["asset-id"], AssetPresenter, ability, nil).and_return([asset_presenter])
    end
    its(:representation_presenters) { is_expected.to contain_exactly(asset_presenter) }
  end

  describe "#preferred_representation_presenters" do
    before do
      allow(solr_doc).to receive(:preferred_representation_id).and_return("asset-id")
      allow(CurationConcerns::PresenterFactory).to receive(:build_presenters).with(
        ["asset-id"], AssetPresenter, ability, nil).and_return([asset_presenter])
    end
    its(:preferred_representation_presenters) { is_expected.to contain_exactly(asset_presenter) }
  end

  describe "#has_relationships?" do
    it { is_expected.not_to have_relationships }
  end
end
