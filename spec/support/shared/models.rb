# frozen_string_literal: true
shared_examples "a model for a Citi resource" do
  subject { described_class.new }

  describe "#to_solr" do
    let(:solr_doc) { subject.to_solr }
    it "has default public read access" do
      expect(solr_doc["read_access_group_ssim"]).to contain_exactly("group", "registered")
    end
    it "has an AIC type" do
      expect(solr_doc["aic_type_sim"]).to include(described_class.to_s)
    end
    it "has a status" do
      expect(solr_doc[Solrizer.solr_name("status", :symbol)]).to eq(["Active"])
    end
  end

  describe "visibility" do
    specify { expect(described_class.visibility).to eql "authenticated" }
  end

  describe "permissions" do
    it { is_expected.not_to be_department }
    it { is_expected.to be_registered }
  end

  describe "RDF type" do
    subject { described_class.new.type }
    it { is_expected.to include(AICType.Resource,
                                AICType.CitiResource,
                                Hydra::PCDM::Vocab::PCDMTerms.Object,
                                Hydra::Works::Vocab::WorksTerms.Work) }
  end

  describe "#edit_groups" do
    its(:edit_groups) { is_expected.to include("registered") }
  end
end

shared_examples "a featureable model" do
  describe "featureability" do
    specify { expect(described_class.new).to be_featureable }
  end
end

shared_examples "an unfeatureable model" do
  describe "featureability" do
    specify { expect(described_class.new).not_to be_featureable }
  end
end

shared_examples "a vocabulary term" do
  describe "::all" do
    subject { described_class.all }
    its(:first) { is_expected.to be_kind_of(ListItem) }
  end

  describe "::options" do
    subject { described_class.options }
    its(:keys) { is_expected.to contain_exactly("Item 1") }
  end
end

shared_examples "a resource that assign representations" do
  let(:resource)                   { described_class.new }
  let(:asset)                      { create(:asset) }
  let(:solr_representations)       { asset.to_solr[Solrizer.solr_name("representation", :facetable)] }
  let(:facets_for_representations) { facets_for(Solrizer.solr_name("representation", :facetable), asset.id) }

  before do
    resource.representations = [asset]
    resource.preferred_representation = asset
    resource.documents = [asset]
    resource.save
  end
  it "contains the correct kind of representations" do
    expect(resource.representations).to include(asset)
    expect(resource.preferred_representation).to eq(asset)
    expect(resource.documents).to include(asset)
    expect(solr_representations).to contain_exactly("Is Document", "Is Representation", "Is Preferred Representation")
    expect(facets_for_representations).to contain_exactly("Is Document", 1, "Is Representation", 1, "Is Preferred Representation", 1)
  end
  context "when removing the representation from the resource" do
    before do
      resource.representations = []
      resource.save
    end
    it "retains the preferred representation" do
      expect(resource.representations).to be_empty
      expect(resource.preferred_representation).to eq(asset)
      expect(solr_representations).to contain_exactly("Is Document", "Is Preferred Representation")
      expect(facets_for_representations).to contain_exactly("Is Document", 1, "Is Preferred Representation", 1)
    end
  end
  context "when removing the asset" do
    before { asset.destroy }
    specify do
      expect(asset.errors).to include(:representations)
      expect(asset).to be_persisted
    end
  end
  context "when reloading as a solr document" do
    let(:solr_doc) { SolrDocument.new(resource.to_solr, nil) }
    subject { solr_doc.to_model }
    its(:preferred_representation) { is_expected.to eq(asset) }
  end
end
