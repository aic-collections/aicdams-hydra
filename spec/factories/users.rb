# frozen_string_literal: true
FactoryGirl.define do
  factory :user do
    factory :user1 do
      email 'user1'
      department '100'
      initialize_with { User.find_or_create_by(email: 'user1') }
    end

    factory :user2 do
      email 'user2'
      department '200'
    end

    factory :admin do
      email 'admin'
      department '100'
    end
  end

  factory :department do
    factory :department100 do
      pref_label "Department 100"
      citi_uid   "100"
    end

    factory :department200 do
      pref_label "Department 200"
      citi_uid   "200"
    end
  end

  factory :aic_user, class: AICUser do
    given_name 'Joe'
    family_name 'Bob'
    nick 'joebob'

    factory :aic_user1 do
      given_name 'First'
      family_name 'User'
      nick 'user1'
    end

    factory :aic_user2 do
      given_name 'Second'
      family_name 'User'
      nick 'user2'
    end

    factory :aic_admin do
      given_name 'Admin'
      family_name 'User'
      nick 'admin'
    end
  end
end
