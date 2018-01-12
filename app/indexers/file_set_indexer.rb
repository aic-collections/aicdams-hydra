# frozen_string_literal: true
class FileSetIndexer < CurationConcerns::FileSetIndexer
  include IndexingBehaviors
  include IndexesDepositors

  def generate_solr_document
    super.tap do |solr_doc|
      solr_doc[Solrizer.solr_name("file_size", :stored_sortable, type: :integer)] = object.file_size[0]
      solr_doc[Solrizer.solr_name("image_height", :searchable, type: :integer)] = dimensions.height
      solr_doc[Solrizer.solr_name("image_width", :searchable, type: :integer)] = dimensions.width
      solr_doc[Solrizer.solr_name("rdf_types", :symbol)] = object.type.map(&:to_s)
      solr_doc["height_is"] = dimensions.height
      solr_doc.merge!("width_is" => dimensions.width)
    end
  end

  private

    def dimensions
      @dimensions ||= FileSetDimensionsService.new(object)
    end
end
