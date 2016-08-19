# frozen_string_literal: true
class RelationshipsController < ApplicationController
  include Blacklight::Catalog

  layout "bare"

  def show
    render_404 unless presenter
    respond_to do |wants|
      wants.html { presenter }
    end
  end

  protected

    def _prefixes
      @_prefixes ||= super + ['curation_concerns/base']
    end

  private

    def presenter
      @presenter ||= RelationshipPresenterBuilder.new(params[:id], params[:model], current_ability, request).call
    end
end
