# frozen_string_literal: true
module PrependedControllers::WithStrippedDownFileSetId
  def image_id
    params[:id].partition("%").first
  end
end