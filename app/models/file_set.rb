# frozen_string_literal: true
class FileSet < ActiveFedora::Base
  include ::CurationConcerns::FileSetBehavior
  include Sufia::FileSetBehavior
  include Permissions
  self.indexer = FileSetIndexer

  def create_derivatives(filename, opts = {})
    create_asset_derivatives(filename)
    create_fulltext_derivatives(filename) unless opts.fetch(:no_text, false)
  end

  private

    # create additional derivatives:
    # jp2 file for image assets
    # pdf for text assets
    # second thumbnail for CITI
    def create_asset_derivatives(filename)
      case mime_type
      when *self.class.image_mime_types
        Hydra::Derivatives::ImageDerivatives.create(filename, outputs: image_outputs)
      when *self.class.pdf_mime_types
        Hydra::Derivatives::PdfDerivatives.create(filename, outputs: pdf_outputs)
      when *self.class.office_document_mime_types
        Derivatives::DocumentDerivatives.create(filename, outputs: [document_output])
      end
    end

    def create_fulltext_derivatives(filename)
      return unless (self.class.office_document_mime_types + self.class.pdf_mime_types).include?(mime_type)
      Hydra::Derivatives::FullTextExtract.create(filename, outputs: [{ url: uri, container: "extracted_text" }])
    end

    # Returns the correct type class for attributes when loading an object from Solr
    # Catches malformed dates that will not parse into DateTime, see #198
    def adapt_single_attribute_value(value, attribute_name)
      AttributeValueAdapter.call(value, attribute_name) || super
    rescue ArgumentError
      "#{value} is not a valid date"
    end

    def image_outputs
      [
        { label: :thumbnail, format: 'jpg', size: '200x150>', url: derivative_url('thumbnail') },
        { label: :access, format: 'jp2', size: '3000x3000>', url: derivative_url('access') },
        { label: :citi, format: 'jpg', size: '96x96>', quality: "90", url: derivative_url('citi') },
        { label: :large, format: 'jpg', size: '1024x1024>', quality: "85", url: derivative_url('large') }
      ]
    end

    def pdf_outputs
      [
        { label: :thumbnail, format: 'jpg', size: '200x150>', layer: 0, url: derivative_url('thumbnail') },
        { label: :citi, format: 'jpg', size: '96x96>', layer: 0, quality: "90", url: derivative_url('citi') },
        { label: :access, format: 'pdf', quality: '90', size: '1024x1024', url: derivative_url('document') }
      ]
    end

    def document_output
      {
        label: :access,
        format: "pdf",
        thumbnail: derivative_url('thumbnail'),
        access: derivative_url('document'),
        citi: derivative_url('citi')
      }
    end

    def derivative_path_factory
      ::DerivativePath
    end
end
