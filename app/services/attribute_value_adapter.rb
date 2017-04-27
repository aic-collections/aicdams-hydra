# frozen_string_literal: true
# When loading objects from Solr, we need to instantiate attributes into
# their corresponding classes. This service does so by examining the
# attribute name and returning its resulting class using the supplied id.
class AttributeValueAdapter
  # @param [Hash] value returned from Solr
  # @param [String] attribute name of the attribute
  def self.call(value, attribute)
    return unless value.present? && value.is_a?(Hash)
    id = value.fetch("id", nil)
    return unless id
    klass = class_mapper.fetch(attribute, nil)
    return unless klass
    klass.find(id)
  end

  def self.class_mapper
    {
      "digitization_source"      => ListItem,
      "document_type"            => Definition,
      "first_document_sub_type"  => Definition,
      "second_document_sub_type" => Definition,
      "keyword"                  => ListItem,
      "compositing"              => ListItem,
      "light_type"               => ListItem,
      "view"                     => ListItem,
      "aic_depositor"            => AICUser,
      "dept_created"             => Department,
      "status"                   => ListItem,
      "preferred_representation" => GenericWork
    }
  end
end
