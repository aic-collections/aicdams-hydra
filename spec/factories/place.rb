# frozen_string_literal: true
FactoryGirl.define do
  factory :place do
    pref_label "Sample Place"

    trait :with_sample_metadata do
      lat "41.881832"
      long "-87.623177"
      uid "PL--1234"
      citi_uid "-1234"
    end
  end
end
