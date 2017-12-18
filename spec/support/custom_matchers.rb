# frozen_string_literal: true
module CustomMatchers
  def match_edit_label(label, opts)
    within('div.generic_file_'.+label.to_s) do
      expect(page).to have_content(opts.fetch(:with, nil))
    end
  end

  def match_help_link(label)
    expect(page).to have_css("a#generic_file_#{label}_help")
  end

  def facets_for(field, id)
    solr_result = Blacklight.default_index.connection.get("select", params: { q: "id:#{id}", "facet" => "true", "facet.field" => field })
    solr_result["facet_counts"]["facet_fields"][field]
  end

  def tabs
    page.all("form.simple_form ul.nav li")
  end

  def document_type_select_options
    find("#generic_work_document_type_uri").all("option")
  end

  def hidden_asset_type
    find("input#hidden_asset_type", visible: false)
  end

  def generic_work_hidden_asset_type
    find("input#generic_work_asset_type", visible: false)
  end

  def selected_document_type
    find("#generic_work_document_type_uri")[:value]
  end

  def selected_first_document_sub_type
    find("#generic_work_first_document_sub_type_uri")[:value]
  end

  def selected_second_document_sub_type
    find("#generic_work_second_document_sub_type_uri")[:value]
  end

  def selected_publish_channel
    find("#generic_work_publish_channel_uris")[:value]
  end
end
