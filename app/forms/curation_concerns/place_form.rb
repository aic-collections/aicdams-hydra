# frozen_string_literal: true
# Generated via
#  `rails generate curation_concerns:work Place`
module CurationConcerns
  class PlaceForm < CurationConcerns::Forms::WorkForm
    self.model_class = ::Place
    include CitiFormBehaviors
  end
end
