# frozen_string_literal: true
# Share job behaviors for converting UploadedFiles into FileSets and attaching them to works.
module AddingFilesToWorks
  # @param [ActiveFedora::Base] the work class
  # @param [Array<UploadedFile>] an array of files to attach
  def perform(work, uploaded_files)
    uploaded_files.each do |uploaded_file|
      file_set = file_set_type(uploaded_file.use_uri)
      user = User.find_by_user_key(work.depositor)
      actor = file_set_actor.new(file_set, user)
      actor.create_metadata(work) do |file|
        file.access_control_id = work.access_control_id
      end

      attach_content(actor, uploaded_file.file)
      uploaded_file.update_attribute(:file_set_uri, file_set.uri)
    end
  end

  private

    # @param [CurationConcerns::Actors::FileSetActor] actor
    # @param [UploadedFileUploader] file
    def attach_content(actor, file)
      case file.file
      when CarrierWave::SanitizedFile
        actor.create_content(file.file.to_file)
      when CarrierWave::Storage::Fog::File
        import_url(actor, file)
      else
        raise ArgumentError, "Unknown type of file #{file.class}"
      end
    end

    # @param [CurationConcerns::Actors::FileSetActor] actor
    # @param [UploadedFileUploader] file
    def import_url(actor, file)
      actor.file_set.update(import_url: file.url)
      log = CurationConcerns::Operation.create!(user: actor.user,
                                                operation_type: "Attach File")
      ImportUrlJob.perform_later(actor.file_set, log)
    end

    def file_set_type(use_uri)
      return FileSet.new if use_uri.nil?
      FileSet.new.tap do |fs|
        fs.type << use_uri
      end
    end

    def file_set_actor
      CurationConcerns::Actors::FileSetActor
    end
end
