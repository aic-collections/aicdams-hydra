# frozen_string_literal: true
FactoryGirl.define do
  factory :operation, class: CurationConcerns::Operation do
    operation_type "Test operation"

    factory :batch_create_operation, class: Sufia::BatchCreateOperation do
      operation_type "Batch Create"
    end
  end
end
