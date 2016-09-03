# frozen_string_literal: true
class AutocompleteController < ActionController::Base
  respond_to :json

  def index
    respond_to do |format|
      format.json do
        res = Blacklight.default_index.connection.get('select', params: build_query(params[:q]))
        data = res["response"]["docs"].map { |x| format_response(SolrDocument.new(x)) }
        render json: data
      end
    end
  end

  private

    def build_query(query)
      {
        qt: "search",
        q:  "*" + (query || '') + "*",
        qf: "pref_label_tesim",
        fl: "pref_label_tesim, uid_ssim, fedora_uri_ssim, thumbnail_path_ss, id",
        fq: "human_readable_type_tesim:#{aic_type}"
      }
    end

    def format_response(doc)
      {
        id: (aic_type =~ /Asset/ ? doc.fedora_uri : doc.id),
        label: doc.pref_label,
        uid: doc.uid,
        thumbnail: doc.thumbnail_path
      }
    end

    def aic_type
      params.fetch(:model, "Asset")
    end
end
