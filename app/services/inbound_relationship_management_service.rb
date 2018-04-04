# frozen_string_literal: true
# Using a provided GenericWork asset, this service updates other resources so that they are referencing
# the asset in a given relationship.
class InboundRelationshipManagementService
  include CurationConcerns::Lockable
  attr_reader :curation_concern, :user

  # @param [GenericWork] resource
  def initialize(resource, user = nil)
    @curation_concern = resource
    @user = user
  end

  # @param [Symbol] relationship such as :representations, :documents, or :attachments
  # @param [Array<String>] ids_or_uris of the resources that will be updated
  def add_or_remove(relationship, ids_or_uris)
    raise NotImplementedError if relationship == :preferred_representations
    ids = ids_or_uris.map { |id| URI.parse(id).path.split("/").last }
    remove(relationship, ids) && add(relationship, ids)
  end

  # @param [Symbol] relationship must be :preferred_representations
  # @param [Array<String>] ids_or_uris of the resources that will be updated
  # In order to keep the interface consistent, you must supply the :preferred_representations relationship
  def update(relationship, ids)
    raise NotImplementedError unless relationship == :preferred_representations
    update_preferred_representations(ids)
  end

  def add_or_remove_representations(ids_or_uris)
    ids = ids_or_uris.map { |id| URI.parse(id).path.split("/").last }
    remove(:representations, ids) && add_with_actor(ids)
  end

  private

    # Removes the given relationship from resources that are not explicitly listed in the array of ids
    def remove(relationship, ids)
      (representing_resource.send(relationship).map(&:id) - ids).each do |old_id|
        acquire_lock_for(old_id) do
          resource_relationship = inverse_relationship(relationship)
          resource = ActiveFedora::Base.find(old_id)
          new_list = resource.send(resource_relationship).map { |r| r unless r.id == curation_concern.id }.compact
          resource.send(resource_relationship.to_s.singularize + "_uris=", new_list.map(&:uri))
          resource.save
        end
      end
    end

    # Updates each of resources in the array of ids and adds the given asset, {curation_concern}, as
    # the relationship for that resource.
    def add(relationship, ids)
      ids.each do |id|
        acquire_lock_for(id) do
          resource_relationship = inverse_relationship(relationship)
          resource = ActiveFedora::Base.find(id)
          new_list = resource.send(resource_relationship.to_s.singularize + "_uris") + [curation_concern.uri]
          resource.send(resource_relationship.to_s.singularize + "_uris=", new_list)
          resource.save
        end
      end
    end

    # Updates the representation and preferred representation of each non-asset id.
    # This is different than #add because we employ the CitiResourceActor which has additional
    # features when editing representation relationships.
    # @todo #add should be replaced with add_with_actor but for all relationships
    def add_with_actor(ids)
      ids.each do |id|
        acquire_lock_for(id) do
          resource = ActiveFedora::Base.find(id)
          attributes = {
            "preferred_representation_uri" => resource.preferred_representation_uri,
            "representation_uris" => (resource.representation_uris + [curation_concern.uri])
          }
          actor = citi_resource_actor(resource)
          actor.update(attributes)
        end
      end
    end

    # Updates each of resources in the array of ids and sets the {curation_concern} as the relationship
    # for that resource.
    # Note: This presently only applies to preferred_representation relationships
    # @todo this should removed and its functions rolled into #add_with_actor. This may require
    #       redefining the interface between AddToCitiResourceActor and this class.
    def update_preferred_representations(ids)
      ids.each do |id|
        acquire_lock_for(id) do
          resource = ActiveFedora::Base.find(id)
          resource.preferred_representation_uri = curation_concern.uri
          unless resource.representation_uris.include?(curation_concern.uri)
            uris = resource.representation_uris + [curation_concern.uri]
            resource.representation_uris = uris
          end
          resource.save
        end
      end
    end

    def representing_resource
      @representing_resource ||= InboundRelationships.new(curation_concern)
    end

    def citi_resource_actor(non_asset)
      CurationConcerns::Actors::ActorStack.new(non_asset, user, [CitiResourceActor])
    end

    # @note This is to preserve the constituents/constituent_of distinction, which wasn't
    #   done properly with attachments.
    def inverse_relationship(relationship)
      return relationship unless relationship == :constituents
      :constituent_of
    end
end
