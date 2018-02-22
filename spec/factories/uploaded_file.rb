# frozen_string_literal: false
FactoryGirl.define do
  f = ActionDispatch::Http::UploadedFile.new(tempfile: File.new("#{Rails.root}/spec/fixtures/sun.png"), filename: "sun.png", content_type: "image/png")

  factory :uploaded_file, class: Sufia::UploadedFile do
    # file f
    # @upload.attributes = { file: uploaded_file, user: current_user, use_uri: use_uri, batch_upload_id: batch_id }
    user
    use_uri "http://file.use.uri"
    batch_upload_id "1"
    uploaded_file f
  end
end
