# frozen_string_literal: true
# Generated via
#  `rails generate curation_concerns:work Exhibition`
module CurationConcerns
  class ExhibitionForm < CurationConcerns::Forms::WorkForm
    self.model_class = ::Exhibition
    include CitiFormBehaviors
  end
end
