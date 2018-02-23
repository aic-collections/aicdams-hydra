# frozen_string_literal: false
FactoryGirl.define do
  factory :file, class: ActionDispatch::Http::UploadedFile do
    skip_create

    factory :image_file do
      tempfile File.new("#{Rails.root}/spec/fixtures/sun.png")
      filename "sun.png"
      content_type "image/png"
    end

    factory :text_file do
      tempfile File.new("#{Rails.root}/spec/fixtures/text.txt")
      filename "text.txt"
      content_type "text/plain"
    end

    initialize_with { new(attributes) }
  end
end
