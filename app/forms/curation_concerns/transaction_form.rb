# frozen_string_literal: true
# Generated via
#  `rails generate curation_concerns:work Transaction`
module CurationConcerns
  class TransactionForm < CurationConcerns::Forms::WorkForm
    self.model_class = ::Transaction
    include CitiFormBehaviors
  end
end
