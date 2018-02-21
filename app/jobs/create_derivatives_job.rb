# frozen_string_literal: true
class CreateDerivativesJob < ActiveJob::Base
  queue_as CurationConcerns.config.ingest_queue_name

  after_perform do |job|
    fileset = job.arguments.first
    fileset_uri = fileset.uri.to_s
    begin
      uploaded_file = Sufia::UploadedFile.find_by_file_set_uri!(fileset_uri)
    rescue ActiveRecord::RecordNotFound => e
      Resque.logger.debug "#{e.message} with file_set_uri of #{fileset_uri}, thus couldn't flip status to 'ingested'."
    else
      unless FileSet.where(digest_ssim: uploaded_file.checksum).empty?
        uploaded_file.update_attribute(:status, "ingested")
      end
    end
  end

  # @param [FileSet] file_set
  # @param [String] file_id identifier for a Hydra::PCDM::File
  # @param [String, NilClass] filepath the cached file within the CurationConcerns.config.working_path
  def perform(file_set, file_id, filepath = nil)
    return if file_set.video? && !CurationConcerns.config.enable_ffmpeg
    filename = CurationConcerns::WorkingDirectory.find_or_retrieve(file_id, file_set.id, filepath)

    file_set.create_derivatives(filename)
    Resque.logger.info("queue running fine: #{CurationConcerns.config.ingest_queue_name}")
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
