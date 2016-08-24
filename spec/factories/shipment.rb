# frozen_string_literal: true
FactoryGirl.define do
  factory :shipment do
    pref_label "Sample Shipment"

    trait :with_sample_metadata do
      pref_label "SH-3469"
      uid "SH-3469"
      citi_uid "3469"
    end
  end
end
