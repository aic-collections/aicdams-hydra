# -*- encoding : utf-8 -*-
# frozen_string_literal: true
class SolrDocument
  include Blacklight::Solr::Document
  include Blacklight::Gallery::OpenseadragonSolrDocument
  # Adds CurationConcerns behaviors to the SolrDocument.
  include CurationConcerns::SolrDocumentBehavior
  # Adds Sufia behaviors to the SolrDocument.
  include Sufia::SolrDocumentBehavior

  include SolrDocumentExtensions

  # self.unique_key = 'id'
  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension(Blacklight::Document::Email)

  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension(Blacklight::Document::Sms)

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension(Blacklight::Document::DublinCore)

  # Do content negotiation for AF models.
  use_extension(Hydra::ContentNegotiation)

  # overrides the MimeTypes included by CurationConcerns::SolrDocumentBehavior in order to add psd types.

  module Hydra::Works::MimeTypes::ClassMethods
    def image_mime_types
      ['image/png', 'image/jpeg', 'image/jpg', 'image/jp2', 'image/bmp', 'image/gif', 'image/tiff', 'image/psd', 'image/vnd.adobe.photoshop']
    end
  end
end
