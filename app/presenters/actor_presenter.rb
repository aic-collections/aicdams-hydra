class ActorPresenter
  include Hydra::Presenter
  include RelatedAssetTerms
  include CitiStatus

  self.model_class = Actor
  self.terms = [
    :birth_date,
    :birth_year,
    :actor_type,
    :death_date,
    :death_year
  ] + CitiResourceTerms.all
  
  def summary_terms
     [ :uid, :created_by, :resource_created, :resource_updated ]
  end

end
