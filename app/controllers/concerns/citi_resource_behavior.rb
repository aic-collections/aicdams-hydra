# frozen_string_literal: true
module CitiResourceBehavior
  extend ActiveSupport::Concern

  included do
    layout "sufia-one-column"
  end

  def index
    redirect_to main_app.search_catalog_path(params.except(:controller, :action).merge(f: { Solrizer.solr_name("aic_type", :facetable) => [self.class.curation_concern_type] }))
  end
end
