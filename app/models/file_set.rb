# frozen_string_literal: true
class FileSet < ActiveFedora::Base
  include ::CurationConcerns::FileSetBehavior
  include Sufia::FileSetBehavior
  include FileSetPermissions

  self.indexer = FileSetIndexer

  def create_derivatives(filename, _opts = {})
    if parent.type.include?(AICType.StillImage)
      create_still_image_derivatives(filename)
    elsif parent.type.include?(AICType.MovingImage)
      create_video_derivatives(filename)
    elsif parent.type.include?(AICType.Sound)
      create_audio_derivatives(filename)
    else
      create_text_derivatives(filename)
    end
  end

  private

    def create_still_image_derivatives(filename)
      return unless AssetType::StillImage.all.include?(mime_type)
      Hydra::Derivatives::ImageDerivatives.create(filename, outputs: image_outputs)
    end

    def create_video_derivatives(filename)
      Hydra::Derivatives::VideoDerivatives.create(filename, outputs: video_outputs)
    end

    def create_audio_derivatives(filename)
      Hydra::Derivatives::AudioDerivatives.create(filename, outputs: audio_outputs)
    end

    def create_text_derivatives(filename)
      return unless AssetType::Text.all.include?(mime_type)
      case mime_type
      when *self.class.image_mime_types
        Hydra::Derivatives::ImageDerivatives.create(filename, outputs: pdf_outputs)
      when *self.class.pdf_mime_types
        Hydra::Derivatives::PdfDerivatives.create(filename, outputs: pdf_outputs)
        Hydra::Derivatives::FullTextExtract.create(filename, outputs: [{ url: uri, container: "extracted_text" }])
      when *self.class.office_document_mime_types
        Derivatives::DocumentDerivatives.create(filename, outputs: [document_output])
        Hydra::Derivatives::FullTextExtract.create(filename, outputs: [{ url: uri, container: "extracted_text" }])
      end
    end

    # Returns the correct type class for attributes when loading an object from Solr
    # Catches malformed dates that will not parse into DateTime, see #198
    # @todo dead method? I don't believe we're loading objects from Solr anymore.
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

    def video_outputs
      [
        { label: :thumbnail, format: 'jpg', url: derivative_url('thumbnail') },
        { label: 'webm', format: 'webm', url: derivative_url('webm') },
        { label: 'mp4', format: 'mp4', url: derivative_url('mp4') }
      ]
    end

    def audio_outputs
      [
        { label: 'mp3', format: 'mp3', url: derivative_url('mp3') },
        { label: 'ogg', format: 'ogg', url: derivative_url('ogg') }
      ]
    end

    def derivative_path_factory
      ::DerivativePath
    end
end
