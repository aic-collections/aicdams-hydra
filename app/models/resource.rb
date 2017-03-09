# frozen_string_literal: true
class Resource < ActiveFedora::Base
  def self.aic_type
    [AICType.Resource]
  end

  # Defines a x_uris= or x_uri= method where "x" is the property
  def self.accepts_uris_for(*fields)
    fields.each do |field|
      if multiple?(field)
        class_eval <<-CODE, __FILE__, __LINE__ + 1
          def #{field.to_s.singularize}_uris=(uris)
            raise(ArgumentError, "argument must be an array") unless uris.kind_of?(Array)
            uris.keep_if(&:present?)
            self.send("#{field}=", uris.map { |x| ::RDF::URI(x) })
          end
          def #{field.to_s.singularize}_uris
            self.send("#{field}").map(&:uri).map(&:to_s)
          end
        CODE

      else
        class_eval <<-CODE, __FILE__, __LINE__ + 1
          def #{field}_uri=(uri)
            resource = uri.present? ? ::RDF::URI(uri) : nil
            self.send("#{field}=", resource)
          end
          def #{field}_uri
            return unless self.send("#{field}")
            self.send("#{field}").uri.to_s
          end
        CODE
      end
    end
  end

  include BasicMetadata
  include ResourceMetadata
  include WithStatus

  type aic_type

  around_save :reindex_relations

  # Re-indexes related objects, i.e. representations, preferred representation, documents, and attachments
  # including those of relations that have just been removed. To do so, we need to query for these relationships
  # in solr, which still exist prior to calling #save.
  def reindex_relations
    ids = solr_relation_ids + relation_ids
    yield
    ids.uniq.map { |id| reindex_related_resource(id) }
  end

  private

    # Returns the correct type class for attributes when loading an object from Solr
    # Catches malformed dates that will not parse into DateTime, see #198
    def adapt_single_attribute_value(value, attribute_name)
      AttributeValueAdapter.call(value, attribute_name) || super
    rescue ArgumentError
      "#{value} is not a valid date"
    end

    def relation_ids
      ids = [documents.map(&:id), representations.map(&:id), attachment_ids].flatten
      ids << preferred_representation.id if preferred_representation
      ids
    end

    def solr_relation_ids
      return [] if id.nil?
      ActiveFedora::SolrService.query(
        "id:#{id}",
        fl: "documents_ssim, preferred_representation_ssim, representations_ssim, attachments_ssim"
      ).first.values.flatten
    end

    def attachment_ids
      return [] unless respond_to?(:attachments)
      attachments.map(&:id)
    end

    def reindex_related_resource(id)
      ActiveFedora::Base.find(id).update_index
    rescue ActiveFedora::ObjectNotFoundError
      Rails.logger.warn("Attempted to reindex related resource #{id}, but it was not found in Fedora.")
    end
end
