# frozen_string_literal: true
class ResourceTerms
  def self.all
    [
      :batch_uid,
      :citi_icon,
      :contributors,
      :created,
      :created_by,
      :documents,
      :preferred_representation,
      :representations,
      :icon,
      :status,
      :uid,
      :updated,
      :description,
      :language,
      :publisher,
      :rights,
      :rights_statement,
      :rights_holder,
      :pref_label,
      :alt_label
    ]
  end

  def self.related_asset_ids
    [:document_ids, :representation_ids, :preferred_representation_id]
  end

  def self.related_assets
    [:documents, :representations, :preferred_representation]
  end
end
