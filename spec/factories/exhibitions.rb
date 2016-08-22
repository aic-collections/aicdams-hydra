# frozen_string_literal: true
FactoryGirl.define do
  factory :exhibition do
    name_official "Sample Exhibition"

    trait :with_sample_metadata do
      description ["This is a very awesome show featuring the very much best artist ever lived."]
      end_date      "2015-10-12"
      name_official "My Very Much Awesome Show"
      name_working  "[WORKING TITLE] My Awesome Show"
      start_date    "2015-08-01"
      citi_uid      "2846"
      pref_label    "EX-2846"
      uid           "EX-2846"
    end
  end
end
