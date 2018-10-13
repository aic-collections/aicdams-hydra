json.array! @data do |doc|
  json.id (@aic_type =~ /Asset/ ? doc.fedora_uri : doc.id)
  json.label doc.pref_label
  json.main_ref_number doc.main_ref_number
  json.uid doc.uid
  json.thumbnail doc.thumbnail_path
  json.show_path polymorphic_path([main_app, doc])
  json.visibility render_visibility_link(doc)
  json.publishing publish_channels_to_badges(doc.publish_channels)
end