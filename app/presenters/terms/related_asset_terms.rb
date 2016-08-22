# frozen_string_literal: true
module RelatedAssetTerms
  delegate :documents, to: :to_model

  delegate :representations, to: :to_model

  delegate :preferred_representation, to: :to_model

  # Not all models have assets
  def assets
    []
  end

  def related_assets
    documents + representations + preferred_representation + assets
  end
end
