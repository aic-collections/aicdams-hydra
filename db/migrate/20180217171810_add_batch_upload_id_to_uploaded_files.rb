class AddBatchUploadIdToUploadedFiles < ActiveRecord::Migration
  def change
    add_reference :uploaded_files, :batch_upload, index: true, foreign_key: true
  end
end
