# frozen_string_literal: true
FactoryGirl.define do
  factory :transaction do
    pref_label "Sample Transaction"

    trait :with_sample_metadata do
      pref_label "TR-123456"
      uid "TR-123456"
      citi_uid "123456"
    end
  end
end
