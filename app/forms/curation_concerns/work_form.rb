# frozen_string_literal: true
# Generated via
#  `rails generate curation_concerns:work Work`
module CurationConcerns
  class WorkForm < CurationConcerns::Forms::WorkForm
    self.model_class = ::Work
    include CitiFormBehaviors
  end
end
