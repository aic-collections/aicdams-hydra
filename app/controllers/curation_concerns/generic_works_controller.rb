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
    asset_with_relationships = []
    if curation_concern.asset_has_relationships?
      asset_with_relationships << curation_concern.to_s
    else
      curation_concern.destroy
    end
    report_status_and_redirect(asset_with_relationships, batch: false)
  end

  def deny_access
    presenter = UnauthorizedPresenter.new(params[:id])
    render template: '/error/unauthorized',
           formats: [:html],
           status: 401,
           locals: { presenter: presenter }
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
end
