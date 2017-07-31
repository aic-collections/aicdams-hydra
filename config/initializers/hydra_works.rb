# frozen_string_literal: true
# Override Hydra::Works::MimeTypes to add additional types

module Hydra::Works::MimeTypes::ClassMethods
  def image_mime_types
    ['image/png',
     'image/jpeg',
     'image/jpg',
     'image/jp2',
     'image/bmp',
     'image/gif',
     'image/tiff']
  end

  def office_document_mime_types
    ['text/rtf',
     'application/msword',
     'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
     'application/vnd.oasis.opendocument.text',
     'application/vnd.ms-excel',
     'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
     'application/vnd.ms-powerpoint',
     'application/vnd.openxmlformats-officedocument.presentationml.presentation',
     'text/plain']
  end
end
