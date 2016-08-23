# frozen_string_literal: true
class AssetPresenter < Sufia::WorkShowPresenter
  self.file_presenter_class = FileSetPresenter

  def self.terms
    [
      :uid,
      :legacy_uid,
      :status,
      :dept_created,
      :aic_depositor,
      :updated,
      :description,
      :batch_uid,
      :language,
      :publisher,
      :pref_label,
      :rights_holder,
      :keyword,
      :created_by,
      :compositing,
      :light_type,
      :view,
      :capture_device,
      :digitization_source,
      :imaging_uid,
      :transcript,
      :modified_date,
      :create_date
    ]
  end

  def self.presenter_terms
    terms + [:fedora_uri, :document_types]
  end

  delegate(*presenter_terms, to: :solr_document)
  delegate :document_ids, :representation_ids, :preferred_representation_ids, to: :relationships

  def title
    [pref_label]
  end

  # TODO: Does this cause a load from Fedora? Use solr_document instead?
  def deleteable?
    current_ability.can?(:delete, GenericWork)
  end

  def asset_type
    return "Image" if model.still_image?
    return "Text Document" if model.text?
  end

  def permission_badge_class
    PermissionBadge
  end

  def citi_presenter?
    false
  end

  def has_relationships?
    !relationships.ids.empty?
  end

  def document_presenters
    CurationConcerns::PresenterFactory.build_presenters(document_ids,
                                                        CitiResourcePresenter,
                                                        *presenter_factory_arguments)
  end

  def representation_presenters
    CurationConcerns::PresenterFactory.build_presenters(representation_ids,
                                                        CitiResourcePresenter,
                                                        *presenter_factory_arguments)
  end

  def preferred_representation_presenters
    CurationConcerns::PresenterFactory.build_presenters(preferred_representation_ids,
                                                        CitiResourcePresenter,
                                                        *presenter_factory_arguments)
  end

  private

    def relationships
      @relationships ||= InboundRelationships.new(id)
    end
end
