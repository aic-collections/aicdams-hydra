# frozen_string_literal: false
FactoryGirl.define do
  factory :image_file, class: ActionDispatch::Http::UploadedFile do
    skip_create
    tempfile File.new("#{Rails.root}/spec/fixtures/sun.png")
    filename "sun.png"
    content_type "image/png"

    initialize_with { new(attributes) }
  end

  factory :text_file, class: ActionDispatch::Http::UploadedFile do
    skip_create
    tempfile File.new("#{Rails.root}/spec/fixtures/text.txt")
    filename "text.txt"
    content_type "text/plain"

    initialize_with { new(attributes) }
  end
end
