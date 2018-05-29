# frozen_string_literal: true
class Sufia::BatchUploadsController < ApplicationController
  include Sufia::BatchUploadsControllerBehavior

  after_action :set_uploaded_file_status, only: [:create]

  def self.form_class
    BatchUploadForm
  end

  def create_update_job
    log = Sufia::BatchCreateOperation.create!(user: current_user,
                                              operation_type: "Batch Create")
    ::BatchAssetCreateJob.perform_later(current_user,
                                        params,
                                        attributes_for_actor,
                                        log)
  end

  protected

    def build_form
      @form = form_class.new(curation_concern, current_ability)
      @form.action_name = action_name
      @form.current_ability = current_ability
      @form.parameterized_relationships = ParameterizedRelationships.new(params)
    end

    def set_uploaded_file_status
      uploaded_file_ids = params["uploaded_files"]
      Sufia::UploadedFile.change_status(uploaded_file_ids, "begun_ingestion")
    end
end
