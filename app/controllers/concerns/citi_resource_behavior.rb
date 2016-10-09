# frozen_string_literal: true
module CitiResourceBehavior
  extend ActiveSupport::Concern

  included do
    with_themed_layout '1_column'
  end

  def index
    redirect_to main_app.search_catalog_path(params.except(:controller, :action).merge(f: { Solrizer.solr_name("aic_type", :facetable) => [resource_type] }))
  end

  private

    # TODO: We should be able to remove this once we've changed GenericWork to Asset
    def resource_type
      return "Asset" if self.class.curation_concern_type == GenericWork
      self.class.curation_concern_type
    end
end
