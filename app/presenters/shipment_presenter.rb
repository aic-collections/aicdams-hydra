class ShipmentPresenter
  include Hydra::Presenter
  include RelatedAssetTerms
  include CitiStatus

  self.model_class = Shipment
  self.terms = CitiResourceTerms.all
  
  def summary_terms
     [ :uid, :created_by, :resource_created, :resource_updated ]
  end

end
