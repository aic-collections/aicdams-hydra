# frozen_string_literal: true
# Combines CharacterizeJob and CreateDerivativeJob from CurationConcerns into one job for the Lakeshore API.
class Lakeshore::CreateAllDerivatives < ActiveJob::Base
  queue_as :api

  # @param [FileSet] file_set
  # @param [String] file_id identifier for a Hydra::PCDM::File
  # @param [String, NilClass] filepath the cached file within the CurationConcerns.config.working_path
  def perform(file_set, file_id, filepath = nil)
    filename = CurationConcerns::WorkingDirectory.find_or_retrieve(file_id, file_set.id, filepath)
    raise LoadError, "#{file_set.class.characterization_proxy} was not found" unless file_set.characterization_proxy?
    CharacterizationService.run(file_set.characterization_proxy, filename)
    Rails.logger.debug "Ran characterization on #{file_set.characterization_proxy.id} (#{file_set.characterization_proxy.mime_type})"
    file_set.characterization_proxy.save!
    file_set.update_index
    file_set.parent.in_collections.each(&:update_index) if file_set.parent
    create_derivatives_job(file_set, file_id, filename)
  end

  def create_derivatives_job(file_set, file_id, filepath = nil)
    return if file_set.video? && !CurationConcerns.config.enable_ffmpeg
    filename = CurationConcerns::WorkingDirectory.find_or_retrieve(file_id, file_set.id, filepath)

    file_set.create_derivatives(filename)

    # Reload from Fedora and reindex for thumbnail and extracted text
    file_set.reload
    file_set.update_index
    file_set.parent.update_index if parent_needs_reindex?(file_set)
    CitiNotificationJob.perform_later(file_set)
  end

  # If this file_set is the thumbnail for the parent work,
  # then the parent also needs to be reindexed.
  def parent_needs_reindex?(file_set)
    return false unless file_set.parent
    file_set.parent.thumbnail_id == file_set.id
  end
end
