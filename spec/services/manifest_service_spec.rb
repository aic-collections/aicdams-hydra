# frozen_string_literal: true
require 'rails_helper'

describe ManifestService do
  let(:asset)     { build(:department_asset, id: "1234", pref_label: "Sample Label") }
  let(:doc)       { SolrDocument.new(asset.to_solr.merge(hasRelatedImage_ssim: ["related-image"])) }
  let(:request)   { double("MockRequest", base_url: "/base_url") }
  let(:presenter) { AssetPresenter.new(doc, Ability.new(nil), request) }
  let(:file_set)  { SolrDocument.new(id: "related-image") }

  subject { described_class.new(presenter) }

  describe "#image_url" do
    before { allow(SolrDocument).to receive(:find).with("related-image").and_return(file_set) }
    it "builds a url using a given derivative type" do
      expect(subject.image_url("acessMaster")).to eq("/downloads/related-image?file=acessMaster")
    end
  end

  describe "#file_set" do
    subject { described_class.new(presenter).file_set }

    context "with an existing file set record" do
      before { allow(SolrDocument).to receive(:find).with("related-image").and_return(file_set) }
      its(:id) { is_expected.to eq("related-image") }
    end

    context "with a non-existent file set record" do
      its(:id) { is_expected.to be_nil }
    end
  end

  describe "#text_or_pdf?" do
    context "with an image asset" do
      it { is_expected.not_to be_text_or_pdf }
    end

    context "with a text asset" do
      let(:asset) { build(:text_asset, id: "1234", pref_label: "Sample Label") }
      it { is_expected.to be_text_or_pdf }
    end

    context "with a pdf asset" do
      let(:asset) { build(:text_asset, id: "1234", pref_label: "Sample Label") }
      let(:file_set) { SolrDocument.new(id: "related-image", mime_type_ssi: "application/pdf") }
      before { allow(SolrDocument).to receive(:find).with("related-image").and_return(file_set) }
      it { is_expected.to be_text_or_pdf }
    end

    context "with a pdf as image" do
      let(:file_set) { SolrDocument.new(id: "related-image", mime_type_ssi: "application/pdf") }
      before { allow(SolrDocument).to receive(:find).with("related-image").and_return(file_set) }
      it { is_expected.not_to be_text_or_pdf }
    end
  end

  describe "#manifest_builder" do
    context "with an image asset" do
      its(:manifest_builder) do
        is_expected.to eq("@context" => "http://iiif.io/api/presentation/2/context.json",
                          "@id" => "http:///base_url/concern/generic_works/1234/manifest",
                          "@type" => "sc:Manifest",
                          "label" => "Sample Label",
                          "viewingHint" => "individuals")
      end
    end

    context "with a text asset" do
      let(:asset) { build(:text_asset, id: "1234", pref_label: "Sample Label") }
      before { allow(SolrDocument).to receive(:find).with("related-image").and_return(file_set) }
      its(:manifest_builder) do
        is_expected.to eq("@context" => [
                            "http://iiif.io/api/image/2/context.json",
                            "http://wellcomelibrary.org/ld/ixif/0/context.json"
                          ],
                          "@id" => "http:///base_url/concern/generic_works/1234/manifest",
                          "@type" => "sc:Manifest",
                          "label" => "Sample Label",
                          "mediaSequences" => [
                            {
                              "@type" => "ixif:MediaSequence",
                              "label" => "Contents",
                              "rendering" => [],
                              "elements" => [
                                {
                                  "@id" => "/downloads/related-image?file=accessMaster",
                                  "format" => "application/pdf",
                                  "@type" => "foaf:Document",
                                  "label" => "Sample Label",
                                  "rendering" => [
                                    {
                                      :@id => "/downloads/related-image?file=accessMaster",
                                      :format => "application/pdf",
                                      :label => "Sample Label"
                                    }
                                  ],
                                  "thumbnail" => "/downloads/related-image?file=thumbnail"
                                }
                              ]
                            }
                          ],
                          "viewingHint" => "individuals")
      end
    end
  end
end
