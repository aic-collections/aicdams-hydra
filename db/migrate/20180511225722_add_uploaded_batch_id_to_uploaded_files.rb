class AddUploadedBatchIdToUploadedFiles < ActiveRecord::Migration
  def change
    add_reference :uploaded_files, :uploaded_batch, index: true, foreign_key: true
  end
end