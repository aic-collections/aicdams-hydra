# frozen_string_literal: true
require 'rails_helper'

describe AssetSolrFieldBuilder do
  let(:asset)                     { build(:still_image_asset) }
  let(:representations)           { Array.wrap(build(:work)) }
  let(:preferred_representations) { Array.wrap(build(:work)) }

  let(:mock_relationships) do
    instance_double("Inbound::Relationships", attachments: ["attachment"],
                                              constituents: ["constituent"],
                                              documents: ["document"],
                                              representations: representations,
                                              preferred_representations: preferred_representations,
                                              preferred_representation: preferred_representations.first)
  end

  subject { described_class.new(asset) }

  context "with no relationships" do
    its(:attachment_facet)               { is_expected.to be_nil }
    its(:attachment_of_facet)            { is_expected.to be_nil }
    its(:constituent_facet)              { is_expected.to be_nil }
    its(:constituent_of_facet)           { is_expected.to be_nil }
    its(:documentation_facet)            { is_expected.to be_nil }
    its(:representation_facet)           { is_expected.to be_nil }
    its(:preferred_representation_facet) { is_expected.to be_nil }
    its(:related_works)                  { is_expected.to include_json([]) }
    its(:main_ref_numbers)               { is_expected.to be_empty }
    its(:representations)                { is_expected.to eq("No Relationship") }
  end

  context "with relationships" do
    before { allow(subject).to receive(:relationships).and_return(mock_relationships) }

    its(:attachment_of_facet)            { is_expected.to eq("Has Attachment") }
    its(:constituent_facet)              { is_expected.to eq("Has Constituent") }
    its(:documentation_facet)            { is_expected.to eq("Documentation For") }
    its(:representation_facet)           { is_expected.to eq("Is Representation") }
    its(:preferred_representation_facet) { is_expected.to eq("Is Preferred Representation") }
    its(:representations)                { is_expected.to contain_exactly("Has Attachment",
                                                                          "Documentation For",
                                                                          "Is Representation",
                                                                          "Has Constituent",
                                                                          "Is Preferred Representation") }
  end

  context "when the subject is an attachment of an asset" do
    before { allow(asset).to receive(:attachments).and_return(["attachment"]) }
    its(:attachment_facet) { is_expected.to eq("Is Attachment") }
  end

  context "when the subject is a constituent of an asset" do
    before { allow(asset).to receive(:constituent_of).and_return(["constituent"]) }
    its(:constituent_of_facet) { is_expected.to eq("Is Constituent") }
  end

  describe "related_works" do
    before { allow(subject).to receive(:relationships).and_return(mock_relationships) }

    context "with missing work data" do
      let(:representations) { Array.wrap(build(:work, :with_sample_metadata, citi_uid: "", main_ref_number: "")) }

      its(:related_works) { is_expected.to include_json([]) }
      its(:main_ref_numbers) { is_expected.to be_empty }
    end

    context "with one relationship" do
      let(:representations) { Array.wrap(build(:work, :with_sample_metadata)) }

      its(:related_works) { is_expected.to include_json([{ citi_uid: "43523", main_ref_number: "1999.397" }]) }
      its(:main_ref_numbers) { is_expected.to contain_exactly("1999.397") }
    end

    context "with two relationships" do
      let(:representations) do
        [
          build(:work, :with_sample_metadata),
          build(:work, :with_sample_metadata, citi_uid: "12345", main_ref_number: "2017.392")
        ]
      end

      its(:related_works) { is_expected.to include_json([{ citi_uid: "43523", main_ref_number: "1999.397" },
                                                         { citi_uid: "12345", main_ref_number: "2017.392" }]) }
      its(:main_ref_numbers) { is_expected.to contain_exactly("1999.397", "2017.392") }
    end

    context "with a preferred representation" do
      let(:preferred_representations) { Array.wrap(build(:work, citi_uid: "12345", main_ref_number: "2017.392")) }

      its(:related_works) { is_expected.to include_json([{ citi_uid: "12345", main_ref_number: "2017.392" }]) }
      its(:main_ref_numbers) { is_expected.to contain_exactly("2017.392") }
    end

    context "with several preferred representations" do
      let(:preferred_representations) do
        [
          build(:work, citi_uid: "54321", main_ref_number: "1720.392"),
          build(:work, citi_uid: "12345", main_ref_number: "2017.392")
        ]
      end

      its(:related_works) { is_expected.to include_json([{ citi_uid: "54321", main_ref_number: "1720.392" },
                                                         { citi_uid: "12345", main_ref_number: "2017.392" }]) }
      its(:main_ref_numbers) { is_expected.to contain_exactly("1720.392", "2017.392") }
    end
  end
end
