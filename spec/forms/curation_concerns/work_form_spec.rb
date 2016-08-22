# frozen_string_literal: true
require 'rails_helper'

describe CurationConcerns::WorkForm do
  let(:user1)   { create(:user1) }
  let(:work)    { Work.new }
  let(:ability) { Ability.new(user1) }
  let(:form)    { described_class.new(work, ability) }

  subject { form }

  its(:representation_terms) do
    is_expected.to contain_exactly(:document_uris, :representation_uris, :preferred_representation_uri)
  end

  its(:document_uris) { is_expected.to be_empty }
  its(:representation_uris) { is_expected.to be_empty }
  its(:preferred_representation_uri) { is_expected.to be_nil }

  describe "::multiple?" do
    it "returns true for multiple representations" do
      expect(described_class.multiple?(:document_uris)).to be true
      expect(described_class.multiple?(:representation_uris)).to be true
    end
  end
end
