# frozen_string_literal: true
class FileSet < ActiveFedora::Base
  include ::CurationConcerns::FileSetBehavior
  include Sufia::FileSetBehavior
  include Permissions
  self.indexer = FileSetIndexer

  # This completely overrides the version in CurationConcerns so that we
  # create a jp2 file for image assets and a pdf for text assets.
  def create_derivatives(filename)
    case mime_type
    when *self.class.image_mime_types
      Hydra::Derivatives::ImageDerivatives.create(filename, outputs: image_outputs)
    when *self.class.pdf_mime_types
      Hydra::Derivatives::PdfDerivatives.create(filename, outputs: pdf_outputs)
      Hydra::Derivatives::FullTextExtract.create(filename, outputs: [{ url: uri, container: "extracted_text" }])
    when *office_document_mime_types
      Derivatives::DocumentDerivatives.create(filename, outputs: [document_output])
      Hydra::Derivatives::FullTextExtract.create(filename, outputs: [{ url: uri, container: "extracted_text" }])
    end
  end

  private

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
        { label: :access, format: 'jp2', url: access_url('jp2') }
      ]
    end

    def pdf_outputs
      [{ label: :thumbnail, format: 'jpg', size: '200x150>', url: derivative_url('thumbnail') }]
    end

    def document_output
      {
        label: :access,
        format: "pdf",
        thumbnail: derivative_url('thumbnail'),
        access: access_url('pdf')
      }
    end

    def office_document_mime_types
      self.class.office_document_mime_types + ["text/plain"]
    end

    # Duplicates #derivative_url but changes the file extension
    def access_url(extension)
      path = derivative_path_factory.derivative_path_for_reference(self, "access")
      URI("file://#{path.gsub(/\.access$/, ".#{extension}")}").to_s
    end
end
