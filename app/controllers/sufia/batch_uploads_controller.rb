# frozen_string_literal: true
class Sufia::BatchUploadsController < ApplicationController
  include Sufia::BatchUploadsControllerBehavior

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
      @form.parameterized_relationships = ParameterizedRelationships.new(params)
    end
end
