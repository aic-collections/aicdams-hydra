# frozen_string_literal: true
class BatchEditsController < ApplicationController
  include Hydra::BatchEditBehavior
  include FileSetHelper
  include Sufia::BatchEditsControllerBehavior
  include AICAssetAfterDeleteBehavior

  before_action :deny_non_admins

  # @note Overrides Sufia to pass current_ability to form instead of current_user
  def edit
    super
    work = form_class.model_class.new
    work.depositor = current_user.user_key
    @form = form_class.new(work, current_ability, batch)
  end

  def update
    case params["update_type"]
    when "update"
      update_batch
    when "delete_all"
      destroy_batch
    end
  end

  def destroy_collection
    assets_with_relationships = []
    batch.each do |doc_id|
      obj = ActiveFedora::Base.find(doc_id, cast: true)
      if obj.asset_has_relationships?
        assets_with_relationships << obj.title
      else
        obj.destroy
      end
    end
    report_status_and_redirect(assets_with_relationships, batch: true)
  end

  # The HTML form is being stupid and for some unknown reason, the array of batch ids being
  # sent to the controller has the anchor tag appended to them ex:
  #   { "batch_document_ids"=>["sx61dm33r", "4b29b601h#descriptions_display"] }
  # I don't know how this happening, so I'm cheating and just lopping them off here.
  def batch
    super.map { |id| id.split(/#/).first }
  end

  def deny_non_admins
    return if current_user.admin?
    flash[:warning] = "Batch edit is only permitted to administrators"
    redirect_to(sufia.dashboard_works_path)
  end

  protected

    def destroy_batch
      batch.each do |doc_id|
        gw = ::GenericWork.find(doc_id)
        report_delete_error unless gw.destroy
      end
      after_update
    end

    def update_batch
      batch.map { |id| update_asset(ActiveFedora::Base.find(id)) }
      flash[:notice] = "Batch update complete"
      after_update
    end

    # Remove (and its commit) when https://github.com/projecthydra/sufia/issues/2450 is closed
    # Updates terms and visibility for a given object in a batch.
    # Note: Visibility is copied down to any contained FileSet objects, but
    #       permissions are not because file sets use the same ACLs as its parent asset.
    def update_asset(obj)
      visibility_changed = visibility_status(obj)
      actor = CurationConcerns::Actors::ActorStack.new(obj, current_user, actor_stack)
      actor.update(work_params)
      VisibilityCopyJob.perform_later(obj) if visibility_changed
    end

    def form_class
      BatchEditForm
    end

    # Use a special subset of the Sufia::ActorFactory.stack_actors only for batch updates
    def actor_stack
      [
        CurationConcerns::Actors::InterpretVisibilityActor,
        AssetActor
      ]
    end

    def visibility_status(object)
      selected_visibility = work_params.fetch(:visibility, nil)
      return false unless selected_visibility
      object.visibility != selected_visibility
    end

    # Overrides CurationConcerns::Collections::AcceptsBatches to redirect to dashboard if the user does
    # not have access to every asset in the batch.
    def filter_docs_with_access!(access_type = :edit)
      super
      redirect_to sufia.dashboard_works_path if flash[:notice].present?
    end
end
