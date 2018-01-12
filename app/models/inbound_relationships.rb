# frozen_string_literal: true
# Tells us what CITI resources a given asset is representing. If the _ids method is called, only
# Solr will be utilized. If the relationship name is used as the method, then the full ActiveFedora
# object will be returned.
class InboundRelationships
  attr_reader :id

  # @param asset [String, GenericWork] the asset in question
  def initialize(asset)
    return unless asset
    @id = asset.is_a?(String) ? asset : asset.id
  end

  delegate :present?, to: :ids

  def ids
    document_ids + representation_ids + preferred_representation_ids + asset_ids
  end

  def documents
    @documents ||= resources_with(:documents_ssim)
  end

  def document_ids
    @document_ids ||= ids_with(:documents_ssim)
  end

  def preferred_representations
    @preferred_representations ||= resources_with(:preferred_representation_ssim)
  end

  def preferred_representation
    preferred_representations.first
  end

  def preferred_representation_ids
    @preferred_representation_ids ||= ids_with(:preferred_representation_ssim)
  end

  def preferred_representation_id
    preferred_representation_ids.first
  end

  def representations
    @representations ||= resources_with(:representations_ssim)
  end

  def representation_ids
    @representation_ids ||= ids_with(:representations_ssim)
  end

  def assets
    @asset_ids ||= resources_with(:attachments_ssim)
  end
  alias attachments assets

  def asset_ids
    @asset_ids ||= ids_with(:attachments_ssim)
  end
  alias attachment_ids asset_ids

  private

    # @return [Array<SolrDocument>]
    def resources_with(solr_field)
      return [] if id.nil?
      ActiveFedora::SolrService.query("#{solr_field}:#{id}", rows: 1000).map { |hit| SolrDocument.new(hit) }
    end

    # @return [Array<String>]
    def ids_with(solr_field)
      return [] if id.nil?
      ActiveFedora::SolrService.query("{!field f=#{solr_field}}#{id}", fl: ActiveFedora.id_field)
                               .map { |x| x.fetch(ActiveFedora.id_field) }
    end
end
