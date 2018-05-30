class AddChecksumToUploadedFiles < ActiveRecord::Migration
  def change
    add_column :uploaded_files, :checksum, :string
    add_index :uploaded_files, :checksum
  end
end