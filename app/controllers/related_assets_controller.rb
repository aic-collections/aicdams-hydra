# frozen_string_literal: true

class RelatedAssetsController < ApplicationController
  include Blacklight::Catalog
  include Blacklight::DefaultComponentConfiguration

  def search_builder_class
    RelatedAssetsSearchBuilder
  end

  copy_blacklight_config_from(CatalogController)

  # @note We want to use Blacklight's views and override them locally. Because of the module namespace
  #       this was creating paths such as catalog/batch. To avoid that, we spell out the exact paths
  #       to use for views.
  def self._prefixes
    ['application', 'related_assets', 'catalog']
  end

  def search; end
end
