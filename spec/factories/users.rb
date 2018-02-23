# frozen_string_literal: true
FactoryGirl.define do
  factory :user do
    factory :user1, aliases: [:default_user] do
      email 'user1'
      department '100'
      initialize_with { User.find_or_create_by(email: 'user1') }
    end

    factory :user2, aliases: [:different_user] do
      email 'user2'
      department '200'
    end

    factory :department_user do
      email 'department_user'
      department '100'
    end

    factory :admin do
      email 'admin'
      department '99'
    end

    factory :apiuser do
      email 'apiuser'
      password 'password'
    end
  end
end

FactoryGirl.define do
  factory :department do
    factory :department100 do
      pref_label "Department 100"
      citi_uid   "100"
    end

    factory :department200 do
      pref_label "Department 200"
      citi_uid   "200"
    end

    factory :admins do
      pref_label "Administrators"
      citi_uid   "99"
    end
  end
end

FactoryGirl.define do
  factory :aic_user, aliases: [:inactive_user], class: AICUser do
    given_name 'Joe'
    family_name 'Bob'
    nick 'joebob'

    factory :aic_user1, aliases: [:active_user] do
      given_name 'First'
      family_name 'User'
      nick 'user1'
      active
    end

    factory :aic_user2 do
      given_name 'Second'
      family_name 'User'
      nick 'user2'
      active
    end

    factory :aic_user3 do
      given_name 'Third'
      family_name 'User'
      nick 'inactiveuser'
    end

    factory :aic_department_user do
      given_name 'Department'
      family_name 'User'
      nick 'department_user'
      active
    end

    factory :aic_admin do
      given_name 'Admin'
      family_name 'User'
      nick 'admin'
      active
    end

    trait :active do
      after(:build) do |user|
        user.type << AIC.ActiveUser
      end
    end
  end
end
