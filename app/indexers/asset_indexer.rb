# frozen_string_literal: true
class AssetIndexer < Sufia::WorkIndexer
  def generate_solr_document
    super.tap do |solr_doc|
      solr_doc[Solrizer.solr_name("aic_type", :facetable)] = aic_types(["Asset"])
      solr_doc[Solrizer.solr_name("representation", :facetable)] = representations
      solr_doc[Solrizer.solr_name("aic_depositor", :symbol)] = object.depositor
      solr_doc[Solrizer.solr_name("document_type", :symbol)] = object.document_type.map(&:pref_label)
      solr_doc[Solrizer.solr_name("fedora_uri", :symbol)] = object.uri.to_s
      solr_doc[Solrizer.solr_name("dept_created", :stored_searchable)] = object.dept_created.pref_label
      solr_doc[Solrizer.solr_name("date_created", :stored_searchable)] = object.date_created.pref_label
      solr_doc[Solrizer.solr_name("date_modified", :stored_searchable)] = object.date_modified.pref_label
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
end
