class ResourcePresenter < Sufia::GenericFilePresenter
  self.terms = [
    :aic_type,
    :batch_uid,
    :contributor,
    :coverage,
    :creator,
    :date,
    :dept_created,
    :description,
    :format,
    :has_location,
    :has_metadata,
    :has_publishing_context,
    :identifier,
    :language,
    :pref_label,
    :publisher,
    :relation,
    :rights,
    :source,
    :subject,
    :title,
    :uid
  ]
end
