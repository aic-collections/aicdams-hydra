# frozen_string_literal: true
class AssetPresenter < Sufia::WorkShowPresenter
  self.file_presenter_class = FileSetPresenter

  delegate :documents, :representations, :preferred_representation, :assets, :representing?, to: :representing_resource

  def self.terms
    [
      :uid,
      :legacy_uid,
      :document_type,
      :status,
      :created,
      :dept_created,
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
      :digitization_source
    ]
  end

  def self.presenter_terms
    terms + [:fedora_uri]
  end

  delegate(*presenter_terms, to: :solr_document)

  def title
    [pref_label]
  end

  def deleteable?
    current_ability.can?(:delete, GenericWork)
  end

  # TODO: needs to show either representation, preferred representation, or document
  def brief_terms
    [
      #:relation,
      :asset_type,
      :uid,
      :pref_label
    ]
  end

  def asset_type
    return "Image" if model.still_image?
    return "Text Document" if model.text?
  end

  def permission_badge_class
    PermissionBadge
  end

  def has_representations?
    false
  end

  def citi_presenter?
    false
  end

  private

    def representing_resource
      @representing_resource ||= RepresentingResource.new(model.id)
    end
end
