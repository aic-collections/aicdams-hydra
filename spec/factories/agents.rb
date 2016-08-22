# frozen_string_literal: true
FactoryGirl.define do
  factory :agent do
    pref_label "Sample Agent"

    trait :with_sample_metadata do
      birth_date ["25-10-1881"]
      birth_year ["1881"]
      death_date ["04-08-1973"]
      death_year ["1973"]
      pref_label "Pablo Picasso (1881-1973)"
      uid        "AC-19646"
      citi_uid "19646"
    end
  end
end
