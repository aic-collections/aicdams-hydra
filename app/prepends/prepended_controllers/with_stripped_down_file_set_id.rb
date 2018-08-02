# frozen_string_literal: true
module PrependedControllers::WithStrippedDownFileSetId
  def image_id
    URI.unescape(params[:id])
  end
end
