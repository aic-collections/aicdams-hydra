class ConservationDocumentType < BaseVocabulary
  def self.query
    List.find_by_label("Conservation Document Type")
  end
end
