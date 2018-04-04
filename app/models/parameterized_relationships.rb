# frozen_string_literal: true
# Given a set of url parameters, this produces a set of relationships between multiple CITI resources and an asset that
# has yet to be created. This is used when a user wants to create a new asset and assign it to any number of CITI resources
# with the same type of relationship. An example would be creating a new asset and making it the documentation for multiple
# CITI exhibitions.
class ParameterizedRelationships
  attr_reader :params

  # @param [ActionController::Parameters] params
  def initialize(params)
    @params = params
  end

  def representations_for
    return [] unless valid? && relationship == "representation_for"
    citi_uid.map { |id| load_type(id) }.compact
  end

  def documents_for
    return [] unless valid? && relationship == "documentation_for"
    citi_uid.map { |id| load_type(id) }.compact
  end

  # Not currently implemented, but is needed to make the form work
  def attachment_uris
    []
  end

  # Not currently implemented, but is needed to make the form work
  def attachments_for
    []
  end

  # Not currently implemented, but is needed to make the form work
  def constituent_of_uris
    []
  end

  # Not currently implemented, but is needed to make the form work
  def has_constituent_part
    []
  end

  private

    def valid?
      citi_type.present? && relationship.present? && citi_uid.is_a?(Array)
    end

    def citi_type
      params.fetch(:citi_type, nil)
    end

    def relationship
      params.fetch(:relationship, nil)
    end

    def citi_uid
      params.fetch(:citi_uid, [])
    end

    # @param [String] id
    # @return [Nil, Object] rescues undefined citi types
    def load_type(id)
      citi_type.constantize.find_by_citi_uid(id, with_solr: true)
    rescue NameError
      nil
    end
end
