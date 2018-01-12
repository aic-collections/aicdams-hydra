# frozen_string_literal: true

require 'hydra-file_characterization'

class FileSetDimensionsService
  attr_reader :file_set, :jp2

  def initialize(file_set)
    @file_set = file_set
    @jp2 = converted_pdf_dimensions
  end

  def width
    return unless width?
    Integer(jp2.width || file_set.width.first)
  end

  def height
    return unless height?
    Integer(jp2.height || file_set.height.first)
  end

  def height?
    file_set.height.present? || jp2.height.present?
  end

  def width?
    file_set.width.present? || jp2.width.present?
  end

  private

    def converted_pdf_dimensions
      return OpenStruct.new(height: nil, width: nil) unless converted?
      OpenStruct.new(height: fits_document.height.first, width: fits_document.width.first)
    end

    def converted?
      return false unless file_set.parent
      file_set.parent.type.include?(AICType.StillImage) && file_set.mime_type == "application/pdf" && jp2_path.present?
    end

    def jp2_path
      DerivativePath.new(file_set).access_path
    end

    def fits_document
      @fits_document ||= build_fits_document
    end

    def build_fits_document
      metadata = extract_metadata(File.open(jp2_path).read)
      omdoc = Hydra::Works::Characterization::FitsDocument.new
      omdoc.ng_xml = Nokogiri::XML(metadata) if metadata.present?
      omdoc
    end

    def extract_metadata(content)
      Hydra::FileCharacterization.characterize(content, "converted_pdf.jp2", :fits) do |cfg|
        cfg[:fits] = Hydra::Derivatives.fits_path
      end
    end
end
