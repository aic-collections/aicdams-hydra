# frozen_string_literal: true
# Service class for constructing Solr fields found in GenericWork resources
class AssetSolrFieldBuilder
  attr_reader :asset

  def initialize(asset)
    @asset = asset
  end

  # @return [String, Array<String>]
  # Returns a listing of representation facets. If none exist, it returns "No Relationship"
  def representations
    representations = [
      attachment_facet, attachment_of_facet, documentation_facet,
      representation_facet, preferred_representation_facet,
      constituent_facet, constituent_of_facet
    ].compact
    representations.empty? ? "No Relationship" : representations
  end

  # @return [String]
  # This method name is incongruent with the actual facet value and will be corrected in #1682
  def attachment_facet
    return if asset.attachments.empty?
    "Is Attachment"
  end

  # @return [String]
  # This method name is incongruent with the actual facet value and will be corrected in #1682
  def attachment_of_facet
    return if relationships.attachments.empty?
    "Has Attachment"
  end

  # @return [String]
  def constituent_facet
    return if relationships.constituents.empty?
    "Has Constituent"
  end

  # @return [String]
  def constituent_of_facet
    return if asset.constituent_of.empty?
    "Is Constituent"
  end

  # @return [String]
  def documentation_facet
    return if relationships.documents.empty?
    "Documentation For"
  end

  # @return [String]
  def representation_facet
    return if relationships.representations.empty?
    "Is Representation"
  end

  # @return [String]
  def preferred_representation_facet
    return if relationships.preferred_representation.nil?
    "Is Preferred Representation"
  end

  # @return [String]
  # A json structure of the asset's representations and preferred representations, containing only the
  # citi_uids and main_ref_numbers of each representation.
  def related_works
    valid_related_works.map do |work|
      { "citi_uid": work.citi_uid, "main_ref_number": work.main_ref_number }
    end.compact.uniq.to_json
  end

  # @return [Array<String>]
  # Only the main_ref_number properties for related works
  def main_ref_numbers
    valid_related_works.map(&:main_ref_number).uniq
  end

  private

    def relationships
      @relationships ||= InboundRelationships.new(asset.id)
    end

    def valid_work?(work)
      if ((work.type.include? AICType.CitiResource) && work.citi_uid.present?) && ((work.respond_to? "main_ref_number") && work.main_ref_number.present?)
        return true
      end
      false
    end

    def valid_related_works
      return [] if relationships.representations.empty? && relationships.preferred_representation.nil?
      all_related_works = relationships.representations + preferreds
      all_related_works.map { |w| w if valid_work?(w) }.compact
    end

    def preferreds
      relationships.preferred_representations.count == 1 ? [relationships.preferred_representation] : relationships.preferred_representations
    end
end
