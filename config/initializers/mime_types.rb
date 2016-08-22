# frozen_string_literal: true
# Custom Mime types

# Add custom mime types
md_mime_type = MIME::Type.new('text/markdown') do |t|
  t.extensions = %w(markdown mdown mkdn md mkd mdwn mdtxt mdtext)
end

MIME::Types.add md_mime_type

# Register application mime types
Mime::Type.register 'application/x-endnote-refer', :endnote
Mime::Type.register "application/n-triples", :nt
Mime::Type.register "application/ld+json", :jsonld
Mime::Type.register "text/turtle", :ttl
