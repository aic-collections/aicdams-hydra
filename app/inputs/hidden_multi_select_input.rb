# frozen_string_literal: true
class HiddenMultiSelectInput < MultiValueInput
  def input_type
    'hidden_multi_select'
  end

  protected

    def outer_wrapper
      <<-HTML
        <input type="hidden" class="autocomplete bigdrop #{attribute_name}" style="width: 600px;">
        <a href="#" class="am-add"
           data-attribute="#{attribute_name}"
           data-model="#{object.model.class.to_s.downcase}"
           data-name="#{input_html_options[:name]}">Add</a>
        <table class="table table-condensed am #{attribute_name}">
          #{yield}
        </table>
      HTML
    end

    def inner_wrapper
      <<-HTML
          <tr class="field-wrapper">
            #{yield}
          </tr>
        HTML
    end

    # TODO: Form object should create solr doc
    def inner_field_wrapper(_value, index)
      <<-HTML
        <td>#{render_thumbnail(resources[index])}</td>
        <td>
          #{resources[index].pref_label}
          #{yield}
        </td>
        <td><a href="#" class="btn btn-danger btn-xs am-delete">Remove</a></td>
      HTML
    end

  private

    def build_field_options(value)
      { value: value, name: input_html_options[:name] }
    end

    def build_field(value, index)
      options = build_field_options(value_for_input(value))
      inner_field_wrapper(value, index) do
        @builder.hidden_field(attribute_name, options)
      end
    end

    def collection
      @collection = object.send(attribute_name)
    end

    def resources
      @resources ||= object.send(options.fetch(:property, attribute_name))
    end

    def render_thumbnail(resource)
      template.render_thumbnail_tag(SolrDocument.new(resource.to_solr))
    end

    def value_for_input(value)
      return value if value.is_a?(String)
      value.id
    end
end
