# frozen_string_literal: true
module CurationConcerns
  class GenericWorkForm < Sufia::Forms::WorkForm
    def self.aic_terms
      [
        :asset_type, :document_type_uris, :pref_label, :created, :description, :language,
        :publisher, :rights_holder_uris, :capture_device, :status_uri, :digitization_source_uri,
        :compositing_uri, :light_type_uri, :view_uris, :keyword_uris
      ]
    end

    self.model_class = ::GenericWork
    # We must inherit from terms even if we aren't using them because Sufia will pass
    # some of them to the controller and they need to be sanitized properly.
    self.terms += aic_terms
    self.required_fields = [:asset_type, :document_type_uris]

    def primary_terms
      self.class.aic_terms
    end

    def secondary_terms
      []
    end

    def uris_for(term)
      model.send(term).map(&:uri).map(&:to_s)
    end

    def uri_for(term)
      return unless model.send(term)
      model.send(term).uri.to_s
    end

    def self.build_permitted_params
      super + [
        { document_type_uris: [] },
        { rights_holder_uris: [] },
        { view_uris: [] },
        { keyword_uris: [] },
        :digitization_source_uri,
        :compositing_uri,
        :light_type_uri,
        :status_uri,
        :asset_type
      ]
    end
  end
end
