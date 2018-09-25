# frozen_string_literal: true
module AssetRelationshipHelper
  # Requires an array of publish channels
  def publish_channels_to_badges(publish_channels)
    html = []

    interpretive_resources = ["Multimedia", "Educational Resources", "Teacher Resources"]

    (publish_channels.to_a - interpretive_resources).each do |publish_channel|
      html << content_tag(:span, publish_channel, title: publish_channel, class: "label label-primary")
    end
    html.join.html_safe
  end
end
