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
        # byebug
        super
      end

      def remove_sub_doc_types(attributes)
        curation_concern.attributes.slice!('first_document_sub_type') unless attributes.keys.include?('first_document_sub_type')
      end

      def apply_save_data_to_curation_concern(attributes)
        attributes[:rights] = Array(attributes[:rights]) if attributes.key? :rights
        remove_blank_attributes!(attributes)
        curation_concern.attributes = attributes
        curation_concern.save
        curation_concern.date_modified = CurationConcerns::TimeService.time_in_utc
      end

      def override_dept_created(dept)
        return unless dept
        curation_concern.dept_created = Department.find_by_citi_uid(dept).uri
      end
    end
  end
end
