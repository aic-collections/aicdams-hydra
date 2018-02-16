class CreateBatchUploads < ActiveRecord::Migration
  def change
    create_table :batch_uploads do |t|

      t.timestamps null: false
    end
  end
end
