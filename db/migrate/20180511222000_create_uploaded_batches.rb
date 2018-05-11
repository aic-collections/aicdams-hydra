class CreateUploadedBatches < ActiveRecord::Migration
  def change
    create_table :uploaded_batches do |t|

      t.timestamps null: false
    end
  end
end