# frozen_string_literal: true
module CurationConcerns
  module Renderers
    class MultilineAttributeRenderer < AttributeRenderer
      def attribute_value_to_html(value)
        ml_value = value.gsub(/(?:\n\r?|\r\n?)/, "<br/>").html_safe
        if microdata_value_attributes(field).present?
          "<span#{html_attributes(microdata_value_attributes(field))}>#{li_value(ml_value)}</span>"
        else
          li_value(ml_value)
        end
      end
    end
  end
end
