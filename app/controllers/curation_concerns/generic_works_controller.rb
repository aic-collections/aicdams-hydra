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
    render json: ManifestService.new(presenter).manifest_builder
  end

  def destroy
    if curation_concern.asset_has_relationships?
      management_service.add_or_remove_representations([])
    end
    curation_concern.destroy
    report_status_and_redirect([], batch: false)
  end

  def deny_access
    presenter = UnauthorizedPresenter.new(params[:id])
    render template: '/error/unauthorized',
           formats: [:html],
           status: 401,
           locals: { presenter: presenter }
  end

  def relationships
    id = params[:id]
    query = "preferred_representation_ssim:#{id}"
    params = { rows: 100, fl: ["id", "pref_label_tesim"] }
    solr_hits = ActiveFedora::SolrService.query(query, params).map do |solr_hit|
      solr_hit_hash = solr_hit.to_h
      cr = ActiveFedora::Base.find(solr_hit_hash["id"])
      solr_hit_hash[:edit_path] = edit_polymorphic_path([main_app, cr])
      solr_hit_hash
    end
    render json: solr_hits
  end

  protected

    # Overrides Sufia to manage file sets which have their ACLs directly linked to the parent asset.
    def after_update_response
      curation_concern.reload
      AclService.new(curation_concern).update if permissions_changed?
      respond_to do |wants|
        wants.html { redirect_to [main_app, curation_concern] }
        wants.json { render :show, status: :ok, location: polymorphic_path([main_app, curation_concern]) }
      end
    end

    def search_builder_class
      AssetSearchBuilder
    end

    # Overrides Sufia to check both visibility and sharing permissions.
    # The asset is reloaded so that removed permissions will be checked.
    def permissions_changed?
      return true if curation_concern.visibility_changed?
      @saved_permissions != curation_concern.permissions.map(&:to_hash)
    end

    def build_form
      @form = form_class.new(curation_concern, current_ability)
      @form.current_ability = current_ability
      @form.action_name = action_name
    end

    def management_service
      @management_service ||= InboundRelationshipManagementService.new(curation_concern, current_user)
    end
end
