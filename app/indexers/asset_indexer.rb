# frozen_string_literal: true
class AssetIndexer < Sufia::WorkIndexer
  def generate_solr_document
    super.tap do |solr_doc|
      solr_doc[Solrizer.solr_name("aic_type", :facetable)] = aic_types(["Asset"])
      solr_doc[Solrizer.solr_name("representation", :facetable)] = representations
      solr_doc[Solrizer.solr_name("aic_depositor", :symbol)] = object.depositor
      solr_doc[Solrizer.solr_name("fedora_uri", :symbol)] = object.uri.to_s
      solr_doc.merge!(pref_label_for(:document_type, as: :symbol))
      solr_doc.merge!(pref_label_for(:first_document_sub_type, as: :symbol))
      solr_doc.merge!(pref_label_for(:second_document_sub_type, as: :symbol))
      solr_doc.merge!(pref_label_for(:digitization_source))
      solr_doc.merge!(pref_label_for(:compositing))
      solr_doc.merge!(pref_label_for(:light_type))
      solr_doc.merge!(pref_label_for(:status))
      solr_doc.merge!(pref_label_for(:dept_created))
    end
  end

  private

    def aic_types(types)
      types << "Still Image" if object.type.include?(AICType.StillImage)
      types << "Text" if object.type.include?(AICType.Text)
      types
    end

    def representations(types = [])
      r = RepresentingResource.new(object.id)
      return types unless r.representing?
      types << "Is Document" unless r.documents.empty?
      types << "Is Representation" unless r.representations.empty?
      types << "Is Preferred Representation" unless r.preferred_representation.nil?
      types
    end

    def pref_label_for(term, opts = {})
      return {} unless object.send(term)
      { Solrizer.solr_name(term.to_s, opts.fetch(:as, :stored_searchable)) => object.send(term).pref_label }
    end
end
