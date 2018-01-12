# frozen_string_literal: true
class HiddenMultiSelectStarsInput < HiddenMultiSelectInput
  include ActionView::Helpers::AssetTagHelper
  def input_type
    'hidden_multi_select_stars'
  end

  protected

    def outer_wrapper
      placeholder = get_data_attribute(html_input_options: input_html_options, data_attribute: 'placeholder')
      endpoint = get_data_attribute(html_input_options: input_html_options, data_attribute: 'endpoint')
      minchars = get_data_attribute(html_input_options: input_html_options, data_attribute: 'minchars')

      <<-HTML
          <input type="hidden" class="autocomplete bigdrop #{attribute_name}" data-placeholder="#{placeholder}" data-endpoint="#{endpoint}" data-minchars="#{minchars}"
             id="#{input_html_options[:id]}">
          <a href="#" class="am-add btn btn-success"
             data-attribute="#{attribute_name}"
             data-model="#{object.model.class.to_s.downcase}"
             data-name="#{input_html_options[:name]}">+ Add</a>
          <table class="table-condensed">
            <thead>
            <tr>
              <th>Pref.</th>
              <th>Thumbnail</th>
              <th>Title</th>
              <th>Actions</th>
            </tr>
            </thead>
          </table>
          <table class="table-condensed am #{attribute_name}">
            #{yield}
          </table>
      HTML
    end

    # TODO: Form object should create solr doc
    def inner_field_wrapper(_value, index)
      <<-HTML
          <td><div class="#{star_or_not(resources[index])}"></div></td>
          <td>#{render_thumbnail(resources[index])}</td>
          <td>
            #{resources[index].pref_label}
      #{yield}
          </td>
          <td><a href="#" class="btn btn-danger am-delete">- Remove</a></td>
      HTML
    end

  private

    def star_or_not(resource)
      if object.preferred_representation.id == resource.id
        "aic-star-on"
      else
        "aic-star-off"
      end
    end
end
