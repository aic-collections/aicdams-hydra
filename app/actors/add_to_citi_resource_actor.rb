# frozen_string_literal: true
# Updates a Citi resource with changes to its relationships from either the create or update
# action of a given asset. This allows the user to add or remove an asset from multiple
# Citi resources at the same time the asset is either created or updated.
#
# Resources are specified in two ways: 1) in the url via a link from the originating resource; or
# 2) assembled in the edit form of the asset.
#
# @attr_reader representations [Array<String>] specified in the form
# @attr_reader additional_representation [String] taken from the url parameters of the referring resource
# @attr_reader documents [Array<String>] specified in the form
# @attr_reader additional_document [String] taken from the url parameters of the referring resource
class AddToCitiResourceActor < CurationConcerns::Actors::AbstractActor
  attr_reader :representations, :additional_representation, :documents, :additional_document

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
    @additional_representation = attributes.delete(:additional_representation)
    @documents = attributes.delete(:documents_for)
    @additional_document = attributes.delete(:additional_document)
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

  def related?
    document_ids.present? || representation_ids.present?
  end

  private

    def add_relationships
      return true unless related?
      add_representations
      add_documents
      true
    end

    # TODO: Refactor into a new service
    def add_representations
      return if representation_ids.empty?
      # remove representations
      (representing_resource.representations.map(&:id) - representation_ids).each do |old_id|
        resource = ActiveFedora::Base.find(old_id)
        new_list = resource.representations.map { |r| r unless r.id == curation_concern.id }.compact
        resource.representations = new_list
        resource.save
        resource.reload
      end

      # add new ones
      representation_ids.each do |id|
        resource = ActiveFedora::Base.find(id)
        resource.representations += [curation_concern]
        resource.save
        resource.reload
      end
    end

    # TODO: Refactor into a new service
    def add_documents
      return if document_ids.empty?
      # remove documents
      (representing_resource.documents.map(&:id) - document_ids).each do |old_id|
        resource = ActiveFedora::Base.find(old_id)
        new_list = resource.documents.map { |r| r unless r.id == curation_concern.id }.compact
        resource.documents = new_list
        resource.save
        resource.reload
      end

      # add new ones
      document_ids.each do |id|
        resource = ActiveFedora::Base.find(id)
        resource.documents += [curation_concern]
        resource.save
        resource.reload
      end
    end

    def representing_resource
      @representing_resource ||= RepresentingResource.new(curation_concern)
    end
end
