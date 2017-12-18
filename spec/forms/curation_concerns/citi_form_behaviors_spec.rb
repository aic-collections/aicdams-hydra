# frozen_string_literal: true
require 'rails_helper'

describe CitiFormBehaviors do
  let(:user1)    { create(:user1) }
  let(:resource) { build(:non_asset) }
  let(:ability)  { Ability.new(user1) }
  let(:form)     { NonAssetForm.new(resource, ability) }

  before(:all) do
    class NonAssetForm < CurationConcerns::Forms::WorkForm
      self.model_class = NonAsset
      include CitiFormBehaviors
    end
  end

  after(:all) do
    Object.send(:remove_const, :NonAssetForm) if defined?(NonAssetForm)
  end

  subject { form }

  its(:representation_terms) do
    is_expected.to contain_exactly(:document_uris, :representation_uris)
  end

  it "responds to hash arguments" do
    expect(subject[:document_uris]).to be_empty
    expect(subject[:representation_uris]).to be_empty
    expect(subject[:preferred_representation_uri]).to be_empty
  end

  describe "::multiple?" do
    it "returns true for multiple representations" do
      expect(NonAssetForm.multiple?(:document_uris)).to be true
      expect(NonAssetForm.multiple?(:representation_uris)).to be true
    end
  end

  context "with no representations" do
    its(:document_uris)                { is_expected.to be_empty }
    its(:documents)                    { is_expected.to be_empty }
    its(:representation_uris)          { is_expected.to be_empty }
    its(:representations)              { is_expected.to be_empty }
    its(:preferred_representation_uri) { is_expected.to be_nil }
    its(:preferred_representation)     { is_expected.to be_kind_of(SolrDocument) }
  end

  context "with representations" do
    let(:asset)    { create(:asset) }
    let(:resource) do
      create(:non_asset,
             representation_uris: [asset.uri],
             document_uris: [asset.uri],
             preferred_representation_uri: asset.uri
            )
    end

    its(:representations)          { is_expected.to contain_exactly(kind_of(SolrDocument)) }
    its(:documents)                { is_expected.to contain_exactly(kind_of(SolrDocument)) }
    its(:preferred_representation) { is_expected.to be_kind_of(SolrDocument) }
  end
end
