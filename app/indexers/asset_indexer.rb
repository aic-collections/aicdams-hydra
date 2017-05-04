# frozen_string_literal: true

class AssetIndexer < Sufia::WorkIndexer
  include IndexingBehaviors

  def generate_solr_document
    super.tap do |solr_doc|
      solr_doc[Solrizer.solr_name("aic_type", :facetable)] = aic_types(["Asset"])
      solr_doc[Solrizer.solr_name("representation", :facetable)] = field_builder.representations
      solr_doc[Solrizer.solr_name("depositor_full_name", :stored_searchable)] = depositor_full_name
      solr_doc[Solrizer.solr_name("aic_depositor", :symbol)] = object.depositor
      solr_doc[Solrizer.solr_name("fedora_uri", :symbol)] = object.uri.to_s
      solr_doc[Solrizer.solr_name("digitization_source", :stored_searchable)] = pref_label_for(:digitization_source)
      solr_doc[Solrizer.solr_name("compositing", :stored_searchable)] = pref_label_for(:compositing)
      solr_doc[Solrizer.solr_name("light_type", :stored_searchable)] = pref_label_for(:light_type)
      solr_doc[Solrizer.solr_name("status", :stored_searchable)] = pref_label_for(:status)
      solr_doc[Solrizer.solr_name("dept_created", :stored_searchable)] = pref_label_for(:dept_created)
      solr_doc[Solrizer.solr_name("dept_created", :facetable)] = pref_label_for(:dept_created)
      solr_doc[Solrizer.solr_name("document_types", :stored_searchable)] = document_types_display
      solr_doc[Solrizer.solr_name("document_types", :facetable)] = document_types_facet
      solr_doc[Solrizer.solr_name("publish_channels", :facetable)] = object.publish_channels.map(&:pref_label)
      solr_doc[Solrizer.solr_name("publish_channels", :symbol)] = object.publish_channels.map(&:pref_label)
      solr_doc[Solrizer.solr_name("attachments", :symbol)] = object.attachments.map(&:id)
      solr_doc[Solrizer.solr_name("related_works", :symbol)] = field_builder.related_works
      solr_doc[Solrizer.solr_name("related_work_main_ref_number", :symbol)] = field_builder.main_ref_numbers
      solr_doc[Solrizer.solr_name("rdf_types", :symbol)] = object.type.map(&:to_s)
    end
  end

  private

    def aic_types(types)
      types << "Still Image" if object.type.include?(AICType.StillImage)
      types << "Text" if object.type.include?(AICType.Text)
      types
    end

    def document_types_facet(types = [])
      types << pref_label_for(:document_type)
      types << pref_label_for(:first_document_sub_type)
      types << pref_label_for(:second_document_sub_type)
      types.compact
    end

    def document_types_display
      [
        pref_label_for(:document_type),
        pref_label_for(:first_document_sub_type),
        pref_label_for(:second_document_sub_type)
      ].compact.join(" > ")
    end

    def field_builder
      @field_builder = AssetSolrFieldBuilder.new(object)
    end
end
