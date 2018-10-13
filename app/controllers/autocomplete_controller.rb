# frozen_string_literal: true
class AutocompleteController < ActionController::Base
  include Sufia::SufiaHelperBehavior
  respond_to :json

  def index
    res = Blacklight.default_index.connection.get('select', params: build_query(params[:q]))
    @data = res["response"]["docs"].map { |x| SolrDocument.new(x) }
  end

  private

    def build_query(query)
      {
        qt: "search",
        q:  "*" + (query || '') + "*",
        qf: ["uid_tesim", "pref_label_tesim", "main_ref_number_tesim", "uid_ssim"],
        fl: "pref_label_tesim, uid_ssim, fedora_uri_ssim, main_ref_number_tesim, thumbnail_path_ss, id, has_model_ssim, publish_channels_ssim",
        fq: "human_readable_type_tesim:#{aic_type}"
      }
    end

    def aic_type
      @aic_type = params.fetch(:model, "Asset")
    end
end
