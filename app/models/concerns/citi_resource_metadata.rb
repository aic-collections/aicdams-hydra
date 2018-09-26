# frozen_string_literal: true
module CitiResourceMetadata
  extend ActiveSupport::Concern

  class_methods do
    def find_by_citi_uid(id, opts = {})
      return unless id
      return find_by_citi_uid_with_solr(id) if opts.fetch(:with_solr, false)
      where(Solrizer.solr_name("citi_uid", :symbol) => id).first
    end

    private

      def find_by_citi_uid_with_solr(id)
        docs = ActiveFedora::SolrService.query("#{Solrizer.solr_name('citi_uid', :symbol)}:#{id}",
                                               rows: 1,
                                               fq: "has_model_ssim:#{self}")
        return nil if docs.empty?
        SolrDocument.new(docs.first)
      end
  end

  included do
    property :citi_uid, predicate: AIC.citiUid, multiple: false do |index|
      index.as :symbol
    end
  end
end
