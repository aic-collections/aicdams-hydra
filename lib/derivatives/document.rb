# frozen_string_literal: true
class Derivatives::Document < Hydra::Derivatives::Processors::Document
  include Hydra::Derivatives::Processors::ShellBasedProcessor

  # Override Hydra::Derivatives::Processors::Document::encode with new method signature and
  # only execute the libreoffice command.
  def self.encode(path, format, outdir)
    execute "#{Hydra::Derivatives.libreoffice_path} --invisible --headless --convert-to #{format} --outdir #{outdir} #{path}"
  end

  # Overrides Hydra::Derivatives::Processors::Document#encode_file to convert the document to pdf and create
  # the thumbnails at the same time.
  def encode_file(_file_suffix, _options = {})
    # convert to pdf
    self.class.encode(source_path, "pdf", Hydra::Derivatives.temp_file_base)
    pdf_file = File.join(Hydra::Derivatives.temp_file_base, [File.basename(source_path, ".*"), 'pdf'].join('.'))

    # persist pdf
    output_file_service.call(File.open(pdf_file, "rb"), url: directives.fetch(:access))

    # create thumbnails from the pdf using Hydra::Derivatives::Processors::Image
    Hydra::Derivatives::Processors::Image.new(pdf_file, thumbnail_directives).process
    Hydra::Derivatives::Processors::Image.new(pdf_file, citi_thumbnail_directives).process

    # clean up
    File.unlink(pdf_file)
  end

  private

    def thumbnail_directives
      { label: :thumbnail, format: 'jpg', size: '200x150>', url: directives.fetch(:thumbnail) }
    end

    def citi_thumbnail_directives
      { label: :citi, format: 'jpg', size: '96x96>', quality: "90", url: directives.fetch(:citi) }
    end
end
