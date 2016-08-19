# frozen_string_literal: true
class PermissionBadge < CurationConcerns::PermissionBadge
  private

    def dom_label_class
      return 'label-warning' if department?
      super
    end

    def link_title
      return 'Department' if department?
      super
    end

    def department?
      @solr_document.visibility == Permissions::LakeshoreVisibility::VISIBILITY_TEXT_VALUE_DEPARTMENT
    end
end
