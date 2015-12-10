class WorkPresenter
  include Hydra::Presenter
  include RelatedAssetTerms
  include CitiStatus

  self.model_class = Work
  self.terms = [
    :artist_uid,
    :citi_uid,
    :creator_display,
    :credit_line,
    :date_display,
    :department,
    :dimensions_display,
    :earliest_date,
    :earliest_year,
    :exhibition_history,
    :gallery_location,
    :asset_ids,
    :inscriptions,
    :latest_date,
    :latest_year,
    :main_ref_number,
    :medium_display,
    :object_type,
    :place_of_origin_uid,
    :provenance_text,
    :publ_ver_level,
    :publication_history,
  ] + CitiResourceTerms.all
  
  def summary_terms
    [ :uid, :main_ref_number, :created_by, :resource_created, :resource_updated ]
  end

  def assets
    self.to_model.assets
  end

end
