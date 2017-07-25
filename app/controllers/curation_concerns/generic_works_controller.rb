# frozen_string_literal: true
class CurationConcerns::GenericWorksController < ApplicationController
  include CurationConcerns::CurationConcernController
  include Sufia::WorksControllerBehavior
  include CitiResourceBehavior
  include AICAssetAfterDeleteBehavior

  self.curation_concern_type = GenericWork
  self.show_presenter = AssetPresenter
  skip_load_and_authorize_resource only: :manifest

  def manifest
    headers['Access-Control-Allow-Origin'] = '*'
    render json:
      ManifestService.new(presenter).manifest_builder
  end

  # overriding CC show action to render the html template for assets, which renders the representative media element in the page's full column width, not sidebar
  def show
    respond_to do |wants|
      wants.html do
        presenter && parent_presenter
        render "curation_concerns/base/show_asset.html.erb", status: :ok
      end
      wants.json do
        # load and authorize @curation_concern manually because it's skipped for html
        @curation_concern = _curation_concern_type.find(params[:id]) unless curation_concern
        authorize! :show, @curation_concern
        render :show, status: :ok
      end
      additional_response_formats(wants)
      wants.ttl do
        render body: presenter.export_as_ttl, content_type: 'text/turtle'
      end
      wants.jsonld do
        render body: presenter.export_as_jsonld, content_type: 'application/ld+json'
      end
      wants.nt do
        render body: presenter.export_as_nt, content_type: 'application/n-triples'
      end
    end
  end

  def destroy
    asset_with_relationships = []
    if curation_concern.asset_has_relationships?
      asset_with_relationships << curation_concern.to_s
    else
      curation_concern.destroy
    end
    report_status_and_redirect(asset_with_relationships, batch: false)
  end
  # we have to override this action in Curation Concerns application controller behavior class

  def deny_access
    presenter = UnauthorizedPresenter.new(params[:id])
    render template: '/error/unauthorized',
           formats: [:html],
           status: 401,
           locals: { presenter: presenter }
  end

  protected

    def search_builder_class
      AssetSearchBuilder
    end
end
