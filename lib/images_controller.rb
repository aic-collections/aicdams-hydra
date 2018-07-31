module ImagesController
  def image_id
    params[:id].partition("/").first
  end
end
