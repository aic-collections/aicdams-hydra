# frozen_string_literal: true

class AssetIndexer < Sufia::WorkIndexer
  include IndexingBehaviors
  include IndexesDepositors

  def generate_solr_document
    super.tap do |solr_doc|
      solr_doc[Solrizer.solr_name("aic_type", :facetable)] = aic_types(["Asset"])
      solr_doc[Solrizer.solr_name("representation", :facetable)] = field_builder.representations
      solr_doc[Solrizer.solr_name("fedora_uri", :symbol)] = object.uri.to_s
      solr_doc[Solrizer.solr_name("digitization_source", :stored_searchable)] = pref_label_for(:digitization_source)
      solr_doc[Solrizer.solr_name("compositing", :stored_searchable)] = pref_label_for(:compositing)
      solr_doc[Solrizer.solr_name("light_type", :stored_searchable)] = pref_label_for(:light_type)
      solr_doc[Solrizer.solr_name("status", :stored_searchable)] = pref_label_for(:status)
      solr_doc[Solrizer.solr_name("document_types", :stored_searchable)] = document_types_display
      solr_doc[Solrizer.solr_name("document_types", :facetable)] = document_types_facet
      solr_doc[Solrizer.solr_name("publish_channels", :facetable)] = object.publish_channels.map(&:pref_label)
      solr_doc[Solrizer.solr_name("publish_channels", :symbol)] = object.publish_channels.map(&:pref_label)
      solr_doc[Solrizer.solr_name("attachments", :symbol)] = object.attachments.map(&:id)
      solr_doc[Solrizer.solr_name("constituent_of", :symbol)] = object.constituent_of.map(&:id)
      solr_doc[Solrizer.solr_name("related_works", :symbol)] = field_builder.related_works
      solr_doc[Solrizer.solr_name("related_work_main_ref_number", :symbol)] = field_builder.main_ref_numbers
      solr_doc[Solrizer.solr_name("rdf_types", :symbol)] = object.type.map(&:to_s)
      solr_doc[Solrizer.solr_name("intermediate_ids", :symbol)] = intermediate_file_set.map(&:id)
      solr_doc[Solrizer.solr_name("original_ids", :symbol)] = original_file_set.map(&:id)
      solr_doc[Solrizer.solr_name("preservation_ids", :symbol)] = preservation_file_set.map(&:id)
      solr_doc[Solrizer.solr_name("legacy_ids", :symbol)] = legacy_file_set.map(&:id)
      solr_doc["public_domain_bsi"] = object.public_domain
      solr_doc["publishable_bsi"] = object.publishable
    end
  end

  private

    def aic_types(types)
      AssetTypeAssignmentService.new(object).current_type.map(&:label) + Array.wrap(types)
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

    # @note Ideally, we could just call {object.members}; however, this is causing some very odd behavior.
    #   Instead, we have to get the member ids and then re-query Solr for their types.
    def cached_members
      @cached_members ||= object.member_ids.map { |id| Member.new(id) }
    end

    def original_file_set
      cached_members.select { |f| f.type.include?(AICType.OriginalFileSet) }
    end

    def intermediate_file_set
      cached_members.select { |f| f.type.include?(AICType.IntermediateFileSet) }
    end

    def preservation_file_set
      cached_members.select { |f| f.type.include?(AICType.PreservationMasterFileSet) }
    end

    def legacy_file_set
      cached_members.select { |f| f.type.include?(AICType.LegacyFileSet) }
    end

    class Member
      attr_reader :id

      def initialize(id)
        @id = id
      end

      def type
        SolrDocument.find(id).type
      end
    end
end
