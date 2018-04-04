# frozen_string_literal: true
# AICWorkShowPresenter subclasses Sufia::WorkShowPresenter
# and adds tiling image and canvas displaying behaviors
class AssetPresenter < Sufia::WorkShowPresenter
  self.file_presenter_class = FileSetPresenter

  def self.terms
    [
      :uid, :legacy_uid, :status, :dept_created, :aic_depositor, :updated,
      :description, :batch_uid, :language, :publisher, :pref_label, :alt_label, :rights_holder,
      :keyword, :created_by, :compositing, :light_type, :view, :capture_device, :digitization_source,
      :imaging_uid, :transcript, :modified_date, :create_date, :publish_channels, :view_notes,
      :visual_surrogate, :external_resources, :licensing_restrictions, :copyright_representatives,
      :caption
    ]
  end

  def self.presenter_terms
    terms + [:document_types, :public_domain?, :publishable?, :type, :related_image_id]
  end

  def manifest_url
    manifest_helper.polymorphic_url([:manifest, self])
  end

  include ResourcePresenterBehaviors

  delegate(*presenter_terms, to: :solr_document)
  delegate :document_ids, :representation_ids, :preferred_representation_ids, to: :relationships

  def title
    [pref_label]
  end

  def fedora_uri
    return unless current_ability.admin?
    solr_document.fedora_uri
  end

  def public_domain
    public_domain? ? "Yes" : "No"
  end

  def publishable
    publishable? ? "Yes" : "No"
  end

  # TODO: Does this cause a load from Fedora? Use solr_document instead?
  def deleteable?
    current_ability.can?(:delete, GenericWork)
  end

  def viewable?
    current_ability.can?(:read, solr_document)
  end

  def permission_badge_class
    PermissionBadge
  end

  def citi_presenter?
    false
  end

  def has_relationships?
    relationships.ids.present? || attachment_ids.present? || constituent_ids.present?
  end

  def artist_presenters?
    false
  end

  def current_location_presenters?
    false
  end

  def still_image?
    type.include?(AICType.StillImage)
  end

  def text?
    type.include?(AICType.Text)
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

  def attachment_presenters
    CurationConcerns::PresenterFactory.build_presenters(solr_document.attachment_ids,
                                                        AssetPresenter,
                                                        *presenter_factory_arguments)
  end

  def attaching_presenters
    CurationConcerns::PresenterFactory.build_presenters(relationships.attachment_ids,
                                                        AssetPresenter,
                                                        *presenter_factory_arguments)
  end

  def constituent_of_presenters
    CurationConcerns::PresenterFactory.build_presenters(solr_document.constituent_of_ids,
                                                        AssetPresenter,
                                                        *presenter_factory_arguments)
  end

  def constituent_presenters
    CurationConcerns::PresenterFactory.build_presenters(relationships.constituent_ids,
                                                        AssetPresenter,
                                                        *presenter_factory_arguments)
  end

  private

    def relationships
      @relationships ||= InboundRelationships.new(id)
    end

    def attachment_ids
      relationships.attachment_ids + solr_document.attachment_ids
    end

    def constituent_ids
      relationships.constituent_ids + solr_document.constituent_of_ids
    end

    def manifest_helper
      @manifest_helper ||= ManifestHelper.new(request.base_url)
    end
end
