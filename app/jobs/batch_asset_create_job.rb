# frozen_string_literal: true
class BatchAssetCreateJob < BatchCreateJob
  # This copies metadata from the passed in attribute to all of the assets that
  # are uploded together
  # @param user [User] the user uploading
  # @param pref_labels [Array<String>] for each of the files
  # @param uploaded_files [Array<Sufia::UploadedFile>]
  # @param attributes [Hash] attributes to apply to all works
  # @param log [BatchCreateOperation]
  def perform(user, pref_labels, uploaded_files, attributes, log)
    log.performing!

    pref_labels ||= {}

    create(user, pref_labels, uploaded_files, attributes, log)
  end

  private

    def create(user, pref_labels, uploaded_files, attributes, log)
      uploaded_files.each do |upload_id|
        attributes = attributes.merge(uploaded_files: [upload_id], pref_label: pref_labels[upload_id])
        model = model_to_create(attributes)
        child_log = CurationConcerns::Operation.create!(user: user,
                                                        operation_type: "Create Asset",
                                                        parent: log)
        CreateWorkJob.perform_later(user, model, attributes, child_log)
      end
    end
end
