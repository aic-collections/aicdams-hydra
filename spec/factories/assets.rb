# frozen_string_literal: true
FactoryGirl.define do
  factory :generic_work, aliases: [:asset_without_type] do
    transient do
      user { FactoryGirl.create(:user1) }
    end

    after(:build) do |asset, evaluator|
      asset.apply_depositor_metadata(evaluator.user)
    end

    factory :still_image_asset, aliases: [:asset] do
      after(:build, &:assert_still_image)

      factory :department_asset do
        visibility Permissions::LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT
      end

      factory :registered_asset do
        visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED
      end
    end

    factory :text_asset do
      after(:build, &:assert_text)
    end

    trait :with_metadata do
      pref_label                   "Asset with metadata"
      description                  ["A sample asset with a complete listing of metadata"]
      document_type_uri            "http://definitions.artic.edu/doctypes/Imaging"
      first_document_sub_type_uri  "http://definitions.artic.edu/doctypes/EventPhotography"
      second_document_sub_type_uri "http://definitions.artic.edu/doctypes/Lecture"
      keyword                      { [create(:list_item, pref_label: "sample keyword")] }
      view                         { [create(:list_item, pref_label: "sample view")] }
      capture_device               "capture device"
      digitization_source          { create(:list_item, pref_label: "digitizaton source") }
      legacy_uid                   ["legacy_uid1", "legacy_uid2"]
      compositing                  { create(:list_item, pref_label: "compositing") }
      imaging_uid                  ["imaging_uid"]
      light_type                   { create(:list_item, pref_label: "light type") }
      transcript                   "a transcript"
      batch_uid                    "batch_uid"
      language                     ["English"]
    end
  end
end
