# frozen_string_literal: true
class AICUser < CitiResource
  self.indexer = AICUserIndexer

  class << self
    def aic_type
      super + [AICType.AICUser, ::RDF::Vocab::FOAF.Agent]
    end

    # @param [String] nick complete match on nick
    # @return [AICUser, SolrDocument, nil]
    def find_by_nick(nick, opts = {})
      if opts.fetch(:with_solr, false)
        find_nick_by_solr(nick)
      else
        where(Solrizer.solr_name("nick", :symbol).to_sym => nick).first
      end
    end

    # @param [String] query partial matches on nick, last name, or user name
    # @return [Array<Hash>, nil]
    def search(query)
      q = Blacklight.default_index.connection.get('select', params: user_query(query))
      response = Blacklight::Solr::Response.new(q, user_query(query))
      response.documents.map { |d| json_result(d) }
    end

    def active_users(query)
      q = Blacklight.default_index.connection.get('select', params: active_user_query(query))
      response = Blacklight::Solr::Response.new(q, active_user_query(query))
      response.documents.map { |d| json_result(d) }
    end

    private

      def active_user_query(query)
        {
          q:  "*" + (query || '') + "*",
          qt: "search",
          df: "nick_tesim",
          qf: "nick_tesim given_name_tesim family_name_tesim",
          fl: "nick_tesim, pref_label_tesim",
          fq: "status_bsi: true"
        }
      end

      def user_query(query)
        {
          q: "#{query}~",
          qt: "search",
          df: "nick_tesim",
          qf: "nick_tesim given_name_tesim family_name_tesim",
          fl: "nick_tesim, pref_label_tesim"
        }
      end

      def json_result(doc)
        {
          id: doc.fetch("nick_tesim").first,
          text: AICUserPresenter.new(find_by_nick(doc.fetch("nick_tesim"))).display_name
        }
      end

      def find_nick_by_solr(nick)
        return nil unless nick
        docs = ActiveFedora::SolrService.query("nick_ssim:#{nick}", rows: 1, fq: 'has_model_ssim:"AICUser"')
        return nil if docs.empty?
        SolrDocument.new(docs.first)
      end
  end

  type aic_type

  # NB: This overrides WithStatus.active? because we use RDF types to determine status and not properties.
  def active?
    type.include?(AIC.ActiveUser)
  end

  property :given_name, predicate: ::RDF::Vocab::FOAF.givenName, multiple: false do |index|
    index.as :stored_searchable
  end

  property :family_name, predicate: ::RDF::Vocab::FOAF.familyName, multiple: false do |index|
    index.as :stored_searchable
  end

  property :nick, predicate: ::RDF::Vocab::FOAF.nick, multiple: false do |index|
    index.as :symbol, :stored_searchable
  end

  def user
    User.find_by_email(nick)
  end
end
