# frozen_string_literal: true
class Derivatives::Document < Hydra::Derivatives::Processors::Document
  include Hydra::Derivatives::Processors::ShellBasedProcessor

  # Override Hydra::Derivatives::Processors::Document::encode with new method signature and
  # only execute the libreoffice command.
  def self.encode(path, format, outdir)
    execute "#{Hydra::Derivatives.libreoffice_path} --invisible --headless --convert-to #{format} --outdir #{outdir} #{path}"
  end

  # Overrides Hydra::Derivatives::Processors::Document#encode_file to convert the document to pdf and create
  # the thumbnail at the same time.
  def encode_file(_file_suffix, _options = {})
    # convert to pdf
    self.class.encode(source_path, "pdf", Hydra::Derivatives.temp_file_base)
    pdf_file = File.join(Hydra::Derivatives.temp_file_base, [File.basename(source_path, ".*"), 'pdf'].join('.'))
    # use converted pdf to create thumbnail
    self.class.encode(pdf_file, "jpg", Hydra::Derivatives.temp_file_base)
    thumbnail = File.join(Hydra::Derivatives.temp_file_base, [File.basename(source_path, ".*"), 'jpg'].join('.'))
    # persist pdf and thumnail to our derivatives
    output_file_service.call(File.open(pdf_file, "rb"), url: directives.fetch(:access))
    output_file_service.call(File.open(thumbnail, "rb"), url: directives.fetch(:thumbnail))
    File.unlink(pdf_file)
    File.unlink(thumbnail)
  end
end
