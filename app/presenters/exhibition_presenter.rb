class ExhibitionPresenter
  include Hydra::Presenter
  include RelatedAssetTerms
  include CitiStatus

  self.model_class = Exhibition
  self.terms = [
    :start_date,
    :end_date,
    :name_official,
    :name_working,
    :type_uid
  ] + CitiResourceTerms.all
  
  def summary_terms
    [ :uid, :name_official, :created_by, :resource_created, :resource_updated ]
  end

end
