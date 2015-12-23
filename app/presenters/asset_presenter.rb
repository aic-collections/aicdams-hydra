class AssetPresenter < Sufia::GenericFilePresenter
  delegate :documents, :representations, :preferred_representations, :assets, :representing?, to: :representing_resource

  def self.asset_terms
    [:asset_capture_device, :digitization_source, :document_type, :legacy_uid, :comments, :tag]
  end

  def self.still_image_terms
    [:compositing, :light_type, :view]
  end

  def self.text_terms
    [:transcript]
  end

  # TODO: :status should be added back to ResourceTerms, see #127
  self.terms = [:title] + ResourceTerms.all + still_image_terms + text_terms + asset_terms + [:status]

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

  def views
    model.view.map(&:pref_label).join(", ")
  end

  def document_types
    model.document_type.map(&:pref_label).join(", ")
  end

  def tags
    model.tag.map(&:pref_label).join(", ")
  end

  private

    def representing_resource
      @representing_resource ||= RepresentingResource.new(model.id)
    end
end
