# frozen_string_literal: true
class DeleteUploadedFileActor < CurationConcerns::Actors::AbstractActor
  # noop
  delegate :update, to: :next_actor

  def create(attributes)
    @uploaded_file_id = attributes.fetch(:uploaded_files, []).first
    next_actor.create(attributes) && delete_uploaded_file
  end

  private
    def delete_uploaded_file
      Sufia::UploadedFile.find_by_id(@uploaded_file_id)&.destroy
    end
end