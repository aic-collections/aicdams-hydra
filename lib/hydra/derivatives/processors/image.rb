# frozen_string_literal: true
require 'mini_magick'
require 'open3'

module Hydra::Derivatives::Processors
  class Image < Processor
    include ShellBasedProcessor
    include Open3
    class_attribute :timeout

    def process
      timeout ? process_with_timeout : determine_whether_to_resize_image
    end

    def process_with_timeout
      Timeout.timeout(timeout) { determine_whether_to_resize_image }
    rescue Timeout::Error
      raise Hydra::Derivatives::TimeoutError, "Unable to process image derivative\nThe command took longer than #{timeout} seconds to execute"
    end

    protected

      # When resizing images, it is necessary to flatten any layers, otherwise the background
      # may be completely black. This happens especially with PDFs. See #110
      # check image type and label here. if pdf and access, simply copy original to directive url, otherwise go about the business of resizing, etc

      def determine_whether_to_resize_image
        if directives.fetch(:label) == :access && load_image_transformer.type =~ /pdf/i
          output_file = directives.fetch(:url).split('file:')[1]
          begin
            _stdin, _stdout, _stderr = popen3("cp #{source_path} #{output_file}")
          rescue StandardError => e
            Rails.logger.error("#{self.class} copy error: #{e}")
          end
        else
          create_resized_image
        end
      end

      def create_resized_image
        create_image do |xfrm|
          if size
            xfrm.flatten
            xfrm.resize(size)
          end
        end
      end

      # flatten psd -> jp2 files properly
      def create_image
        xfrm = directives.fetch(:format) == "jp2" && load_image_transformer.type =~ /psd/i ? load_image_transformer : selected_layers(load_image_transformer)

        yield(xfrm) if block_given?
        xfrm.format(directives.fetch(:format))
        xfrm.quality(quality.to_s) if quality
        write_image(xfrm)
      end

      # We need to adjust our *-access jp2s; mogrify will ensure they actually are in the jp2 format if they aren't.

      def execute_mogrify_commands(output_file:, arguments:)
        Image.execute("#{ENV['hydra_bin_path']}mogrify #{arguments} #{output_file}")
      rescue StandardError => e
        Rails.logger.error("#{self.class} mogrify error. #{e}")
      end

      def write_image(xfrm)
        output_io = StringIO.new
        xfrm.write(output_io)
        output_io.rewind
        str = output_file_service.call(output_io, directives)

        if file_should_be_mogrified(directives)
          execute_mogrify_commands(output_file: directives[:url].split("file:")[1], arguments: add_sharpening(directives))
        end
        str
      end

      # Override this method if you want a different transformer, or need to load the
      # raw image from a different source (e.g. external file)
      def load_image_transformer
        MiniMagick::Image.open(source_path)
      end

    private

      def file_should_be_mogrified(directives)
        if (directives[:url].include?("access") && directives[:url].include?("jp2")) || directives[:url].include?("citi")
          return true
        end
        false
      end

      def add_sharpening(directives)
        directives[:url].include?("citi") ? "-sharpen 1,.5" : ""
      end

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
