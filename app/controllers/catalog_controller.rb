# frozen_string_literal: true
class CatalogController < ApplicationController
  include Hydra::Catalog
  include Hydra::Controller::ControllerBehavior
  include Sufia::Catalog
  include BlacklightAdvancedSearch::Controller

  # These before_filters apply the hydra access controls
  before_action :enforce_show_permissions, only: :show
  skip_before_action :default_html_head

  def self.uploaded_field
    solr_name('date_uploaded', :stored_sortable, type: :date)
  end

  def self.modified_field
    solr_name('date_modified', :stored_sortable, type: :date)
  end

  def self.file_size_field
    solr_name("file_size", :stored_sortable, type: :long)
  end

  # disable the bookmark control from displaying in gallery view
  # Sufia doesn't show any of the default controls on the list view, so
  # this method is not called in that context.
  def render_bookmarks_control?
    false
  end

  # Overrides Sufia::Catalog
  def search_builder_class
    CatalogSearchBuilder
  end

  configure_blacklight do |config|
    config.view.gallery.partials = [:index_header, :index]
    config.view.masonry.partials = [:index]
    config.view.slideshow.partials = [:index]

    config.show.tile_source_field = :content_metadata_image_iiif_info_ssm
    # default advanced config values
    config.advanced_search ||= Blacklight::OpenStructWithHashAccess.new
    # config.advanced_search[:qt] ||= 'advanced'
    config.advanced_search[:url_key] ||= 'advanced'
    config.advanced_search[:query_parser] ||= 'edismax'
    config.advanced_search[:form_solr_parameters] ||= {}

    config.search_builder_class = Sufia::SearchBuilder

    ## Default parameters to send to solr for all search-like requests. See also SolrHelper#solr_search_params
    config.default_solr_params = {
      qt: "search",
      rows: 10
    }

    # solr field configuration for document/show views
    config.index.title_field = solr_name("pref_label", :stored_searchable)
    config.index.display_type_field = solr_name("has_model", :symbol)
    config.index.thumbnail_field = 'thumbnail_path_ss'

    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    config.add_facet_field solr_name("aic_type", :facetable), label: "Resource Type", limit: 5
    config.add_facet_field solr_name("creator", :facetable), label: "Creator", limit: 5
    config.add_facet_field solr_name("keyword", :facetable), label: "Keyword", limit: 5
    config.add_facet_field solr_name("subject", :facetable), label: "Subject", limit: 5
    config.add_facet_field solr_name("language", :facetable), label: "Language", limit: 5
    config.add_facet_field solr_name("based_near", :facetable), label: "Location", limit: 5
    config.add_facet_field solr_name("publisher", :facetable), label: "Publisher", limit: 5
    config.add_facet_field solr_name("file_format", :facetable), label: "File Format", limit: 5
    config.add_facet_field solr_name("image_width", :searchable, type: :integer), label: "Image Width", range: true
    config.add_facet_field solr_name("image_height", :searchable, type: :integer), label: "Image Height", range: true
    config.add_facet_field solr_name("representation", :facetable), label: "Relationship"
    config.add_facet_field solr_name("document_types", :facetable), label: AIC.documentType.label
    config.add_facet_field solr_name("dept_created", :facetable), label: AIC.deptCreated.label
    config.add_facet_field solr_name("publish_channels", :facetable), label: AIC.publishChannel.label
    config.add_facet_field solr_name("collection_type", :facetable), label: AIC.collectionType.label

    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.add_facet_fields_to_solr_request!

    # Index view fields
    config.add_index_field solr_name("depositor", :stored_searchable),       label: "Depositor", link_to_search: true
    config.add_index_field solr_name("pref_label", :stored_searchable),      label: "Title"
    config.add_index_field solr_name("uid", :symbol),                        label: AIC.uid.label
    config.add_index_field solr_name("main_ref_number", :stored_searchable), label: AIC.mainRefNumber.label
    config.add_index_field solr_name("document_types", :stored_searchable),  label: AIC.documentType.label, helper_method: :link_to_each_facet_field, helper_facet: solr_name("document_types", :facetable).to_sym
    config.add_index_field solr_name("resource_type", :stored_searchable),   label: "Resource Type"
    config.add_index_field solr_name('credit_line', :stored_searchable),     label: AIC.creditLine.label
    config.add_index_field solr_name('dept_created', :stored_searchable),    label: AIC.deptCreated.label, link_to_search: solr_name("dept_created", :facetable).to_sym
    config.add_index_field solr_name('department', :stored_searchable),      label: AIC.department.label
    config.add_index_field solr_name('collection_type', :symbol),            label: AIC.collectionType.label
    config.add_index_field solr_name("relationships", :stored_searchable, type: :integer), label: "Related Assets"
    config.add_index_field solr_name("date_uploaded", :stored_sortable, type: :date),      label: "Date Uploaded", itemprop: 'datePublished', helper_method: :human_readable_date
    config.add_index_field solr_name("date_modified", :stored_sortable, type: :date),      label: "Date Modified", itemprop: 'dateModified', helper_method: :human_readable_date

    # Resource fields
    config.add_show_field solr_name("contributor", :stored_searchable),   label: AIC.contributor.label
    config.add_show_field solr_name("created_by", :stored_searchable),    label: AIC.createdBy.label
    config.add_show_field solr_name("description", :stored_searchable),   label: ::RDF::Vocab::DC.description.label
    config.add_show_field solr_name("label", :stored_searchable),         label: ::RDF::RDFS.label.label
    config.add_show_field solr_name("language", :stored_searchable),      label: ::RDF::Vocab::DC.language.label
    config.add_show_field solr_name("pref_label", :stored_searchable),    label: ::RDF::Vocab::SKOS.prefLabel.label
    config.add_show_field solr_name("alt_label", :stored_searchable), label: ::RDF::Vocab::SKOS.altLabel.label
    config.add_show_field solr_name("publisher", :stored_searchable),     label: ::RDF::Vocab::DC.publisher.label
    config.add_show_field solr_name("rights", :stored_searchable),        label: ::RDF::Vocab::DC.rights.label
    config.add_show_field solr_name("rights_holder", :stored_searchable), label: ::RDF::Vocab::DC.rightsHolder.label
    config.add_show_field solr_name("same_as", :stored_searchable),       label: ::RDF::OWL.sameAs.label
    config.add_show_field solr_name("uid", :stored_searchable),           label: AIC.uid.label
    config.add_show_field solr_name("batch_uid", :stored_searchable),     label: AIC.batchUid.label

    # Asset fields
    config.add_show_field solr_name("caption", :stored_searchable), label: AIC.nonObjCaption.label

    # Work fields
    config.add_show_field solr_name("artist", :stored_searchable), label: AIC.artist.label
    config.add_show_field solr_name("citi_uid", :stored_searchable),            label: AIC.citiUid.label
    config.add_show_field solr_name("creator_display", :stored_searchable),     label: AIC.creatorDisplay.label
    config.add_show_field solr_name("credit_line", :stored_searchable),         label: AIC.creditLine.label
    config.add_show_field solr_name("current_location", :stored_searchable), label: AIC.currentLocation.label
    config.add_show_field solr_name("date_display", :stored_searchable),        label: AIC.dateDisplay.label
    config.add_show_field solr_name("dimensions_display", :stored_searchable),  label: AIC.dimensionsDisplay.label
    config.add_show_field solr_name("earliest_year", :stored_searchable),       label: AIC.earliestYear.label
    config.add_show_field solr_name("exhibition_history", :stored_searchable),  label: AIC.exhibitionHistory.label
    config.add_show_field solr_name("gallery_location", :stored_searchable),    label: AIC.galleryLocation.label
    config.add_show_field solr_name("inscriptions", :stored_searchable),        label: AIC.inscriptions.label
    config.add_show_field solr_name("latest_year", :stored_searchable),         label: AIC.latestYear.label
    config.add_show_field solr_name("main_ref_number", :stored_searchable),     label: AIC.mainRefNumber.label
    config.add_show_field solr_name("medium_display", :stored_searchable),      label: AIC.mediumDisplay.label
    config.add_show_field solr_name("object_type", :stored_searchable),         label: AIC.objectType.label
    config.add_show_field solr_name("provenance_text", :stored_searchable),     label: AIC.provenanceText.label
    config.add_show_field solr_name("publ_ver_level", :stored_searchable),      label: AIC.publVerLevel.label
    config.add_show_field solr_name("publication_history", :stored_searchable), label: AIC.publicationHistory.label

    config.add_show_field solr_name("earliest_date", :stored_searchable, type: :date), label: AIC.earliestDate.label
    config.add_show_field solr_name("latest_date", :stored_searchable, type: :date),   label: AIC.latestDate.label

    # Generic File fields (from base Sufia install)
    config.add_show_field solr_name("tag", :stored_searchable), label: "Keyword"
    config.add_show_field solr_name("subject", :stored_searchable), label: "Subject"
    config.add_show_field solr_name("creator", :stored_searchable), label: "Creator"
    config.add_show_field solr_name("based_near", :stored_searchable), label: "Location"
    config.add_show_field solr_name("date_uploaded", :stored_searchable), label: "Date Uploaded"
    config.add_show_field solr_name("date_modified", :stored_searchable), label: "Date Modified"
    config.add_show_field solr_name("date_created", :stored_searchable), label: "Date Created"
    config.add_show_field solr_name("resource_type", :stored_searchable), label: "Asset Type"
    config.add_show_field solr_name("format", :stored_searchable), label: "File Format"
    config.add_show_field solr_name("identifier", :stored_searchable), label: "Identifier"

    # Collection fields
    config.add_show_field solr_name("title", :stored_searchable), label: "Title"

    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different.
    #
    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise.
    config.add_search_field('all_fields', label: 'All Fields', include_in_advanced_search: false) do |field|
      all_names = config.show_fields.values.map(&:field).join(" ")
      title_name = solr_name("title", :stored_searchable)
      field.solr_parameters = {
        qf: "#{all_names} file_format_tesim all_text_timv",
        pf: title_name.to_s
      }
    end

    # Now we see how to over-ride Solr request handler defaults, in this
    # case for a BL "search field", which is really a dismax aggregate
    # of Solr search fields.
    # creator, title, description, publisher, date_created,
    # subject, language, resource_type, format, identifier, based_near,
    config.add_search_field('contributor') do |field|
      # solr_parameters hash are sent to Solr as ordinary url query params.
      field.solr_parameters = { "spellcheck.dictionary": "contributor" }

      # :solr_local_parameters will be sent using Solr LocalParams
      # syntax, as eg {! qf=$title_qf }. This is neccesary to use
      # Solr parameter de-referencing like $title_qf.
      # See: http://wiki.apache.org/solr/LocalParams
      solr_name = solr_name("contributor", :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('creator') do |field|
      field.solr_parameters = { "spellcheck.dictionary": "creator" }
      solr_name = solr_name("creator", :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('title') do |field|
      field.solr_parameters = {
        "spellcheck.dictionary": "title"
      }
      solr_name = solr_name("title", :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('description') do |field|
      field.label = "Abstract or Summary"
      field.solr_parameters = {
        "spellcheck.dictionary": "description"
      }
      solr_name = solr_name("description", :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('publisher') do |field|
      field.solr_parameters = {
        "spellcheck.dictionary": "publisher"
      }
      solr_name = solr_name("publisher", :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('date_created') do |field|
      field.include_in_advanced_search = false
      field.solr_parameters = {
        "spellcheck.dictionary": "date_created"
      }
      solr_name = solr_name("created", :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('subject') do |field|
      field.solr_parameters = {
        "spellcheck.dictionary": "subject"
      }
      solr_name = solr_name("subject", :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('language') do |field|
      field.include_in_advanced_search = false
      field.solr_parameters = {
        "spellcheck.dictionary": "language"
      }
      solr_name = solr_name("language", :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('resource_type') do |field|
      field.include_in_advanced_search = false
      field.solr_parameters = {
        "spellcheck.dictionary": "resource_type"
      }
      solr_name = solr_name("resource_type", :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('format') do |field|
      field.include_in_advanced_search = false
      field.solr_parameters = {
        "spellcheck.dictionary": "format"
      }
      solr_name = solr_name("format", :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('identifier') do |field|
      field.include_in_advanced_search = false
      field.solr_parameters = {
        "spellcheck.dictionary": "identifier"
      }
      solr_name = solr_name("id", :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('based_near') do |field|
      field.include_in_advanced_search = false
      field.label = "Location"
      field.solr_parameters = {
        "spellcheck.dictionary": "based_near"
      }
      solr_name = solr_name("based_near", :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('tag') do |field|
      field.include_in_advanced_search = false
      field.solr_parameters = {
        "spellcheck.dictionary": "tag"
      }
      solr_name = solr_name("tag", :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('depositor') do |field|
      solr_name = solr_name("depositor", :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('rights') do |field|
      field.include_in_advanced_search = false
      solr_name = solr_name("rights", :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    # label is key, solr field is value
    config.add_sort_field "score desc, #{uploaded_field} desc", label: "relevance"
    config.add_sort_field "#{uploaded_field} desc", label: "date uploaded \u25BC"
    config.add_sort_field "#{uploaded_field} asc", label: "date uploaded \u25B2"
    config.add_sort_field "#{modified_field} desc", label: "date modified \u25BC"
    config.add_sort_field "#{modified_field} asc", label: "date modified \u25B2"
    config.add_sort_field "#{file_size_field} desc", label: "file size \u25BC"
    config.add_sort_field "#{file_size_field} asc", label: "file size \u25B2"

    # If there are more than this many search results, no spelling ("did you
    # mean") suggestion is offered.
    config.spell_max = 5
  end
end
