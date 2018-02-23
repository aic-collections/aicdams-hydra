# frozen_string_literal: false
FactoryGirl.define do
  factory :uploaded_file, class: Sufia::UploadedFile do
    association :file, factory: :image_file
    association :user, factory: :default_user
    use_uri "http://file.use.uri"
    batch_upload_id "1"

    factory :uploaded_file_that_began_ingestion do
      status "begun_ingestion"
    end
  end
end
