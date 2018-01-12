# frozen_string_literal: true
# Overrides Hydra::Works::CharacterizationService to prevent values from accreting on the binary's fcr:metadata node.
class CharacterizationService < Hydra::Works::CharacterizationService
  protected

    # Assign values of the instance properties from the metadata mapping :prop => val
    def store_metadata(terms)
      terms.each_pair do |term, value|
        property = property_for(term)
        next if property.nil?
        # Array-ify the value to avoid a conditional here
        append_property_value(property, Array.wrap(value))
      end
    end

    def append_property_value(property, value)
      object.send("#{property}=", value)
    end
end
