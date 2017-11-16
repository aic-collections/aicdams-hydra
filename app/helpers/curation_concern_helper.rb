module CurationConcernHelper
  # https://cits.artic.edu/redmine/issues/2183
  # we needed different titles when uploading single asset vs multiple assets
  # if it's a GenericWork, it's a single asset, if it's not, it's a BatchUploadItem
  def custom_h1(curation_concern)
    if curation_concern.is_a?(GenericWork)
      "Create New Asset"
    else
      t("sufia.assets.#{action_name}.header")
    end
  end
end
