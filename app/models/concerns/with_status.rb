# frozen_string_literal: true
module WithStatus
  extend ActiveSupport::Concern

  included do
    property :status, predicate: AIC.status, multiple: false, class_name: "ListItem"

    accepts_uris_for :status

    def active?
      status == ListItem.active_status
    end
  end
end
