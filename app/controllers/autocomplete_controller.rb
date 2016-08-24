# frozen_string_literal: true
class AutocompleteController < ActionController::Base
  respond_to :json

  def index
    respond_to do |format|
      format.json do
        res = Blacklight.default_index.connection.get('select', params: build_query(params[:q]))
        data = res["response"]["docs"].map do |x|
          { uri: x["fedora_uri_ssim"], uid: x["uid_ssim"], prefLabel: x["pref_label_ssim"] }
        end
        render json: data
      end
    end
  end

  private

    def build_query(query)
      {
        q: "*" + (query || '') + "*",
        df: "pref_label_tesim, uid_tesim",
        fl: "pref_label_ssim, uid_ssim, fedora_uri_ssim",
        fq: "human_readable_type_tesim:Asset"
      }
    end
end
