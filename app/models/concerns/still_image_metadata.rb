# frozen_string_literal: true
module StillImageMetadata
  extend ActiveSupport::Concern

  included do
    property :compositing, predicate: AIC.compositing, multiple: false, class_name: "ListItem"

    property :imaging_uid, predicate: AIC.imagingUid do |index|
      index.as :symbol
    end

    property :light_type, predicate: AIC.lightType, multiple: false, class_name: "ListItem"

    property :view, predicate: AIC.view, multiple: true, class_name: "ListItem" do |index|
      index.as :stored_searchable, :facetable, using: :pref_label
    end

    accepts_uris_for :compositing, :light_type, :view
  end
end
