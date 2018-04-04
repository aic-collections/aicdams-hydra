# frozen_string_literal: true
# Updates a Citi resource with changes to its relationships from either the create or update
# action of a given asset. This allows the user to add or remove an asset from multiple
# Citi resources or other assets at the same time the asset is either created or updated.
#
# Resources are specified in two ways: 1) in the url via a link from the originating resource; or
# 2) assembled in the edit form of the asset.
#
# @attr_reader representations [Array<String>] specified in the form
# @attr_reader additional_representation [String] taken from the url parameters of the referring resource
# @attr_reader documents [Array<String>] specified in the form
# @attr_reader additional_document [String] taken from the url parameters of the referring resource
class AddToCitiResourceActor < CurationConcerns::Actors::AbstractActor
  include CurationConcerns::Lockable

  attr_reader :representations, :preferred_representations, :additional_representation, :documents,
              :additional_document, :attachments, :constituents

  def create(attributes)
    delete_relationship_attributes(attributes)
    next_actor.create(attributes) && add_relationships
  end

  def update(attributes)
    delete_relationship_attributes(attributes)
    add_relationships && next_actor.update(attributes)
  end

  def delete_relationship_attributes(attributes)
    @representations = attributes.delete(:representations_for)
    @preferred_representations = attributes.delete(:preferred_representation_for)
    @additional_representation = attributes.delete(:additional_representation)
    @documents = attributes.delete(:documents_for)
    @additional_document = attributes.delete(:additional_document)
    @attachments = attributes.delete(:attachments_for)
    @constituents = attributes.delete(:has_constituent_part)
  end

  # Assembles all unique representation ids, removing any empty strings passed in from the form.
  # @return [Array<String>]
  # TODO: we may want to cast to uris instead?
  def representation_ids
    (Array.wrap(representations) + Array.wrap(additional_representation)).uniq.delete_if(&:empty?)
  end

  # Assembles all unique document ids, removing any empty strings passed in from the form.
  # @return [Array<String>]
  # TODO: we may want to cast to uris instead?
  def document_ids
    (Array.wrap(documents) + Array.wrap(additional_document)).uniq.delete_if(&:empty?)
  end

  # Assembles all unique preferred_representation ids, removing any empty strings passed in from the form.
  # @return [Array<String>]
  # TODO: we may want to cast to uris instead?
  def preferred_representation_ids
    Array.wrap(preferred_representations).uniq.delete_if(&:empty?)
  end

  # Assets are referenced using uris and not ids
  # @return [Array<String>]
  def attachment_uris
    Array.wrap(attachments).uniq.delete_if(&:empty?)
  end

  # Assets are referenced using uris and not ids
  # @return [Array<String>]
  def constituent_uris
    Array.wrap(constituents).uniq.delete_if(&:empty?)
  end

  private

    # @todo wrap this in an async job? If the list of ids is very long, these updates will be done
    #       synchronously and would impact UX.
    def add_relationships
      management_service.add_or_remove_representations(representation_ids)
      management_service.add_or_remove(:documents, document_ids)
      management_service.add_or_remove(:attachments, attachment_uris)
      management_service.add_or_remove(:constituents, constituent_uris)
      management_service.update(:preferred_representations, preferred_representation_ids)
      true
    end

    def management_service
      @management_service ||= InboundRelationshipManagementService.new(curation_concern, user)
    end
end
