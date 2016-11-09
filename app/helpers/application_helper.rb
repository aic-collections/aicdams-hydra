# frozen_string_literal: true
module ApplicationHelper
  def resource_type_facets
    @resource_types.reject { |r| r.is_a?(Integer) }.sort
  end

  def render_documents(presenter)
    return unless presenter.document_presenters.present?
    render 'relationship', rel_term: "Documentation", rel_term_asset: "Documentation For", presenters: presenter.document_presenters
  end

  def render_representations(presenter)
    return unless presenter.representation_presenters.present?
    render 'relationship', rel_term: "Representations", rel_term_asset: "Representation Of", presenters: presenter.representation_presenters
  end

  def render_preferred_representations(presenter)
    return unless presenter.preferred_representation_presenters.present?
    render 'relationship', rel_term: "Preferred Representation", rel_term_asset: "Preferred Representation Of", presenters: presenter.preferred_representation_presenters
  end

  def render_linked_attributes(presenter)
    return unless presenter.present? && presenter.first.alt_display_label
    solr_doc = presenter.first.solr_document
    label = presenter.first.alt_display_label

    render 'linked_attribute', attribute_doc: solr_doc, attribute_label: label
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
end
