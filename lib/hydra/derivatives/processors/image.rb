# frozen_string_literal: true
require 'mini_magick'
require 'open3'

module Hydra::Derivatives::Processors
  class Image < Processor
    include ShellBasedProcessor
    include Open3
    class_attribute :timeout

    def process
      timeout ? process_with_timeout : create_resized_image
    end

    def process_with_timeout
      Timeout.timeout(timeout) { create_resized_image }
    rescue Timeout::Error
      raise Hydra::Derivatives::TimeoutError, "Unable to process image derivative\nThe command took longer than #{timeout} seconds to execute"
    end

    protected

      # When resizing images, it is necessary to flatten any layers, otherwise the background
      # may be completely black. This happens especially with PDFs. See #110
      def create_resized_image
        create_image do |xfrm|
          if size
            xfrm.flatten
            xfrm.resize(size)
          end
        end
      end

      def create_image
        xfrm = selected_layers(load_image_transformer)
        yield(xfrm) if block_given?
        xfrm.format(directives.fetch(:format))
        xfrm.quality(quality.to_s) if quality
        write_image(xfrm)
      end

      # We need to adjust our *-access jp2s; mogrify will ensure they actually are in the jp2 format if they aren't, and we need to resize them if their width is over 3k, to save on storage space. At some point we might perform these operations during the jp2 conversion process, but for now this will suffice.
      def write_image(xfrm)
        output_io = StringIO.new
        xfrm.write(output_io)
        output_io.rewind

        str = output_file_service.call(output_io, directives)
        if directives[:url].include?("access") && directives[:url].include?("jp2")
          output_file = directives[:url].split("file:")[1]
          begin
            _stdin, stdout, _stderr = popen3("#{Rails.application.secrets.hydra_bin_path}identify -format %w #{output_file}")
            width = stdout.read
            if width.to_i > 3000
              Image.execute "#{Rails.application.secrets.hydra_bin_path}mogrify -resize 3000x #{output_file}"
            else
              Image.execute("#{Rails.application.secrets.hydra_bin_path}mogrify #{output_file}")
            end
          rescue StandardError => e
            Rails.logger.error("#{self.class} mogrify error. #{e}")
          end
        end
        str
      end

      # Override this method if you want a different transformer, or need to load the
      # raw image from a different source (e.g. external file)
      def load_image_transformer
        MiniMagick::Image.open(source_path)
      end

    private

      def size
        directives.fetch(:size, nil)
      end

      def quality
        directives.fetch(:quality, nil)
      end

      def selected_layers(image)
        if image.type =~ /pdf/i
          image.layers[directives.fetch(:layer, 0)]
        elsif directives.fetch(:layer, false)
          image.layers[directives.fetch(:layer)]
        else
          image
        end
      end
  end
end
