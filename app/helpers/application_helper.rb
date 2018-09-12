# frozen_string_literal: true
module ApplicationHelper
  NAMES = { "local" => "LCL:",
            "dev" => "DEV:",
            "staging" => "STG:",
            "test" => "TST:",
            "production" => ""
  }.freeze
  def env_title_prefix
    env_var = Figaro.env.LAKESHORE_ENV
    NAMES[env_var] ? NAMES[env_var] : ""
  end

  def resource_type_facets
    @resource_types.reject { |r| r.is_a?(Integer) }.sort
  end

  def render_linked_attributes(presenter)
    return unless presenter.present? && presenter.first.alt_display_label
    solr_doc = presenter.first.solr_document
    label = presenter.first.alt_display_label

    render 'linked_attribute', attribute_doc: solr_doc, attribute_label: label
  end

  def render_asset_relationship(presenters, heading, need_star = false, *args)
    return unless presenters.present?
    render "asset_relationship", heading: heading, presenters: presenters, need_star: need_star, pref_rep_id: args[0]
  end

  def render_citi_relationship(presenters, heading)
    return unless presenters.present?
    render "citi_relationship", heading: heading, presenters: presenters
  end

  def link_to_citi(model, citi_uid)
    citi_tbl_ids = {
      Work: 3,
      Agent: 54,
      Place: 7,
      Exhibition: 151,
      Transaction: 167,
      Shipment: 180
    }
    citi_tbl_id = citi_tbl_ids[model.to_sym]
    link_to "View this #{model} in CITI", "http://citiworker10.artic.edu:8080/edit/?tableID=" + citi_tbl_id.to_s + "&uid=" + citi_uid.to_s, target: "_blank", class: "btn btn-default citi-btn"
  end

  def link_to_each_facet_field(options)
    raise ArgumentError unless options[:config] && options[:value] && options[:config][:helper_facet]
    facet_search = options[:config][:helper_facet]
    facet_fields = options[:value].first.split(">").each(&:strip!)
    facet_links = facet_fields.map do |type|
      link_to(type, main_app.search_catalog_path(f: { facet_search => [type] }))
    end
    safe_join(facet_links, " > ")
  end

  def use_uri_options
    if controller_name == "generic_works"
      default_use_uris.unshift([AICType.IntermediateFileSet.label, AICType.IntermediateFileSet])
    else
      default_use_uris
    end
  end

  def star_or_not(rep_uri, pref_rep_uri)
    if rep_uri == pref_rep_uri
      "aic-star-on"
    else
      "aic-star-off"
    end
  end

  def citi_models
    ["Agent", "Exhibition", "Place", "Shipment", "Transaction", "Work"]
  end

  private

    def default_use_uris
      [
        ["No role", nil],
        [AICType.OriginalFileSet.label, AICType.OriginalFileSet],
        [AICType.PreservationMasterFileSet.label, AICType.PreservationMasterFileSet],
        [AICType.LegacyFileSet.label, AICType.LegacyFileSet]
      ]
    end
end
