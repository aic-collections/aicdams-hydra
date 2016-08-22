# frozen_string_literal: true
# Generated via
#  `rails generate curation_concerns:work Agent`
module CurationConcerns
  class AgentForm < CurationConcerns::Forms::WorkForm
    self.model_class = ::Agent
    include CitiFormBehaviors
  end
end
