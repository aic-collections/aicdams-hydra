# frozen_string_literal: false
FactoryGirl.define do
  factory :file, class: ActionDispatch::Http::UploadedFile do
    skip_create

    factory :image_file do
      tempfile File.new("#{Rails.root}/spec/fixtures/sun.png")
      filename "sun.png"
      content_type "image/png"

      factory :intermediate_upload do
        tempfile File.new("#{Rails.root}/spec/fixtures/tardis.png")
      end

      factory :original_upload do
        tempfile File.new("#{Rails.root}/spec/fixtures/tardis2.png")
      end

      factory :presevation_master_upload do
        tempfile File.new("#{Rails.root}/spec/fixtures/text.png")
      end
    end

    factory :text_file do
      tempfile File.new("#{Rails.root}/spec/fixtures/text.txt")
      filename "text.txt"
      content_type "text/plain"
    end

    factory :oddball_file2 do
      tempfile File.new("#{Rails.root}/spec/fixtures/api_409.json")
      filename "409.json"
      content_type "image/png"
    end

    initialize_with { new(attributes) }
  end
end
