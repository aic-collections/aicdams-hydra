# frozen_string_literal: true
class DerivativePath < CurationConcerns::DerivativePath
  class << self
    def access_path(object)
      new(object).access_path
    end
  end

  # Returns the path with a file called a "access"
  def access_path
    all_paths.select do |file|
      file if File.basename(file, ".*") =~ /access/
    end.first
  end

  private

    def file_name
      return unless destination_name
      if destination_name == "document"
        "access.pdf"
      else
        destination_name + extension
      end
    end

    def extension
      case destination_name
      when 'thumbnail'
        ".#{MIME::Types.type_for('jpg').first.extensions.first}"
      when 'citi'
        ".jpg"
      when 'access'
        ".jp2"
      when 'large'
        ".jpg"
      else
        ".#{destination_name}"
      end
    end
end
