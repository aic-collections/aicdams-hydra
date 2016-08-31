# frozen_string_literal: true
shared_examples "a form for a Citi resource" do
  its(:representation_terms) do
    is_expected.to contain_exactly(:document_uris, :representation_uris, :preferred_representation_uri)
  end

  its(:document_uris) { is_expected.to be_empty }
  its(:documents) { is_expected.to be_empty }
  its(:representation_uris) { is_expected.to be_empty }
  its(:representations) { is_expected.to be_empty }
  its(:preferred_representation_uri) { is_expected.to be_nil }
  its(:preferred_representation) { is_expected.to be_nil }

  it "responds to hash arguments" do
    expect(subject[:document_uris]).to be_empty
    expect(subject[:representation_uris]).to be_empty
    expect(subject[:preferred_representation_uri]).to be_empty
  end

  describe "::multiple?" do
    it "returns true for multiple representations" do
      expect(described_class.multiple?(:document_uris)).to be true
      expect(described_class.multiple?(:representation_uris)).to be true
    end
  end
end
