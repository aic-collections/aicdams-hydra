# frozen_string_literal: true
# This is used in place of CurationConcerns::WorkSearchBuilder so that discovery permissions
# are not included in show views.
class AssetSearchBuilder < SearchBuilder
  include CurationConcerns::SingleResult

  self.default_processor_chain += [:remove_discovery_permissions]

  # Hack method to remove permissions added by Blacklight::AccessControls::Enforcement
  # Ideally, we'd override that class or use a custom one that doesn't add the discovery
  # permissions in the first place.
  def remove_discovery_permissions(solr_parameters)
    fq = solr_parameters.fetch(:fq, nil)
    return unless fq
    solr_parameters[:fq] = fq.map { |q| prune(q) }
  end

  private

    # @param query [String] solr filter query created from a search builder
    # Return any query that doesn't contain "disover_access"
    # Otherwise, remove all discover_access queries and return the new, rejoined query
    def prune(query)
      return query unless query =~ /discover_access/
      query.split("OR").delete_if { |q| q =~ /discover_access/ }.join("OR")
    end
end
