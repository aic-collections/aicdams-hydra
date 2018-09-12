# frozen_string_literal: true
class RelatedAssetsSearchBuilder < SearchBuilder
  self.default_processor_chain += [
    :show_related_assets
  ]

  # Search for ids returned from
  def show_related_assets(solr_parameters)
    solr_parameters[:q] = related_assets_with_citi_uid_and_model
  end

  private

    def related_assets_with_citi_uid_and_model
      "{!join from=#{relationship_solr_field[relationship_type_key]} to=#{ActiveFedora.id_field}}#{citi_query}"
    end

    def citi_query
      "citi_uid_ssim:#{citi_uids} AND #{limit_to_citi_model}"
    end

    def citi_uids
      case
      when resource_ids.empty?
        "*"
      when resource_ids.count == 1
        resource_ids.first
      else
        "(#{resource_ids.join(' OR ')})"
      end
    end

    def limit_to_citi_model
      "has_model_ssim:#{citi_model}"
    end

    def relationship_solr_field
      {
        "hasDocumentation" => "documents_ssim",
        "hasRepresentation" => "representations_ssim",
        "hasPreferredRepresentation" => "preferred_representation_ssim"
      }
    end

    def relationship_type_key
      blacklight_params.fetch(:relationship_type)
    end

    def citi_model
      blacklight_params.fetch(:model)
    end

    def resource_ids
      @resource_ids ||= blacklight_params.fetch(:resource_id).split(/,/).map(&:strip)
    end
end
