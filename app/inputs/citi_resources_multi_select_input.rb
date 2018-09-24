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
        <td>
          #{template.link_to(resources[index].uid, curation_concerns_work_path(resources[index].id), target: '_blank')}
        </td>
        <td>
          #{template.link_to(resources[index].pref_label, curation_concerns_work_path(resources[index].id), target: '_blank')}
          #{yield}
        </td>
        <td>
          #{(template.link_to(resources[index].main_ref_number, curation_concerns_work_path(resources[index].id), target: '_blank')) if resources[index].has_model == "Work"}
        </td>
        <td><a href="#" class="btn btn-danger am-delete">- Remove</a></td>
      HTML
    end

  private

    def get_data_attribute(html_input_options: options, data_attribute:)
      if html_input_options && html_input_options[:data] && html_input_options[:data][:"#{data_attribute}"]

        html_input_options[:data][:"#{data_attribute}"]
      end
    end

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

    # @param [SolrDocument, GenericWork] resource
    # @todo Further optimizations would make this method take only a SolrDocument
    def render_thumbnail(resource)
      solr_document = resource.is_a?(SolrDocument) ? resource : SolrDocument.new(resource.to_solr)
      template.render_thumbnail_tag(solr_document)
    end

    def value_for_input(value)
      return value if value.is_a?(String)
      value.id
    end
end
