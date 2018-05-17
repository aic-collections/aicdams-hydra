class AddStatusToUploadedFiles < ActiveRecord::Migration
  def change
    add_column :uploaded_files, :status, :string
  end
end