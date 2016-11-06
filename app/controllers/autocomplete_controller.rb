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
        qf: ["uid_tesim", "pref_label_tesim", "main_ref_number_tesim", "uid_ssim"],
        fl: "pref_label_tesim, uid_ssim, fedora_uri_ssim, main_ref_number_tesim, thumbnail_path_ss, id",
        fq: "human_readable_type_tesim:#{aic_type}"
      }
    end

    def format_response(doc)
      {
        id: (aic_type =~ /Asset/ ? doc.fedora_uri : doc.id),
        label: doc.pref_label,
        main_ref_number: doc.main_ref_number,
        uid: doc.uid,
        thumbnail: doc.thumbnail_path
      }
    end

    def aic_type
      params.fetch(:model, "Asset")
    end
end
