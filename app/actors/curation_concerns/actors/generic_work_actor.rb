# frozen_string_literal: true
# Generated via
#  `rails generate curation_concerns:work GenericWork`
module CurationConcerns
  module Actors
    class GenericWorkActor < CurationConcerns::Actors::BaseActor
      def create(attributes)
        override_dept_created(attributes.delete("dept_created"))
        asset_type = RDF::URI(attributes.delete("asset_type"))
        AssetTypeAssignmentService.new(curation_concern).assign(asset_type)
        super
      end

      def update(attributes)
        attributes.delete("asset_type")
        super
      end

      def override_dept_created(dept)
        return unless dept
        curation_concern.dept_created = Department.find_by_citi_uid(dept).uri
      end
    end
  end
end
