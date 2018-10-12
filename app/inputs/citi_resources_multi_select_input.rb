# frozen_string_literal: true
class CitiResourcesMultiSelectInput < HiddenMultiSelectInput
  def input_type
    'citi_resources_multi_select'
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
           data-input-class="citi_resources_multi_select"
           data-attribute="#{attribute_name}"
           data-model="#{object.model.class.to_s.downcase}"
           data-name="#{input_html_options[:name]}">+ Add</a>
        <table class="table table-striped am #{attribute_name}">
          <thead>
            <tr>
              <th>UID</th>
              <th>Title</th>
              <th>Main Ref #</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            #{yield}
          </tbody>
        </table>
      HTML
    end

    # TODO: Form object should create solr doc
    def inner_field_wrapper(_value, index)
      <<-HTML
        <td>
          #{template.link_to(resources[index].uid, curation_concerns_work_path(resources[index].id), target: '_blank')}
        </td>
        <td>
          #{template.link_to(resources[index].pref_label, curation_concerns_work_path(resources[index].id), target: '_blank')}
          #{yield}
        </td>
        <td>
          #{template.link_to(resources[index].main_ref_number, curation_concerns_work_path(resources[index].id), target: '_blank') if resources[index].has_model == 'Work'}
        </td>
        <td><a href="#" class="btn btn-danger am-delete">- Remove</a></td>
      HTML
    end
end
