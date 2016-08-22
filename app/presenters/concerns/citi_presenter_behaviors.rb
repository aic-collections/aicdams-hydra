# frozen_string_literal: true
module CitiPresenterBehaviors
  extend ActiveSupport::Concern

  included do
    delegate(*terms, to: :solr_document)
    delegate(:document_ids, :representation_ids, :preferred_representation_id, to: :solr_document)
  end

  def title
    [pref_label]
  end

  def document_presenters
    CurationConcerns::PresenterFactory.build_presenters(document_ids,
                                                        AssetPresenter,
                                                        *presenter_factory_arguments)
  end

  def representation_presenters
    CurationConcerns::PresenterFactory.build_presenters(representation_ids,
                                                        AssetPresenter,
                                                        *presenter_factory_arguments)
  end

  def preferred_representation_presenters
    CurationConcerns::PresenterFactory.build_presenters([preferred_representation_id],
                                                        AssetPresenter,
                                                        *presenter_factory_arguments)
  end

  def has_relationships?
    document_presenters.present? || representation_presenters.present? || preferred_representation_presenters.present?
  end

  def citi_presenter?
    true
  end

  # Because Citi resources do not have a full compliment of permissions,
  # we allow anyone to edit
  def editor?
    true
  end

  def deleteable?
    false
  end

  private

    def ids_for_representation(solr_field)
      ActiveFedora::SolrService.query("{!field f=#{solr_field}}#{id}", fl: ActiveFedora.id_field)
                               .map { |x| x.fetch(ActiveFedora.id_field) }
    end
end
