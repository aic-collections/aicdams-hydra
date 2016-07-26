# frozen_string_literal: true
module ApplicationHelper
  def resource_type_facets
    @resource_types.reject { |r| r.is_a?(Integer) }.sort
  end

  def render_documents(presenter)
    return unless presenter.document_presenters.present?
    render 'representations', representation: "Documents", presenters: presenter.document_presenters
  end

  def render_representations(presenter)
    return unless presenter.representation_presenters.present?
    render 'representations', representation: "Representations", presenters: presenter.representation_presenters
  end

  def render_preferred_representations(presenter)
    return unless presenter.preferred_representation_presenters.present?
    render 'representations', representation: "Preferred Representation", presenters: presenter.preferred_representation_presenters
  end
end
