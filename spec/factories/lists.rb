# frozen_string_literal: true
FactoryGirl.define do
  factory :list do
    transient do
      items []
    end

    pref_label "List of things"
    edit_users ["user2"]

    factory :private_list do
      edit_users []
    end

    after(:build) do |list|
      list.members << build(:list_item)
    end
  end

  trait :with_items do
    after(:build) do |list, attrs|
      attrs.items.each do |i|
        list.members << build(:list_item, pref_label: i)
      end
    end
  end

  factory :status, class: List do
    pref_label "Status"

    after(:build) do |list|
      list.members << build(:status_type)
    end
  end

  factory :list_item do
    pref_label "Item 1"
  end

  factory :status_type do
    pref_label "Active"
  end
end
