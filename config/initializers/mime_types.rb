# frozen_string_literal: true

# Custom mime types
md_mime_type = MIME::Type.new("text/markdown") do |t|
  t.extensions = %w(markdown mdown mkdn md mkd mdwn mdtxt mdtext)
end
MIME::Types.add md_mime_type

fp_mime_type = MIME::Type.new("application/x-filemaker") do |t|
  t.extensions = %w(fp7 fp12)
end
MIME::Types.add fp_mime_type

twbx_mime_type = MIME::Type.new("application/twbx") do |t|
  t.extensions = %w(twbx)
end
MIME::Types.add twbx_mime_type

flv_mime_type = MIME::Type.new("video/x-flv") do |t|
  t.extensions = %w(f4a f4b)
end
MIME::Types.add flv_mime_type

mts_mime_type = MIME::Type.new("video/mts") do |t|
  t.extensions = %w(mts)
end
MIME::Types.add mts_mime_type

mp4_mime_type = MIME::Type.new("audio/m4a") do |t|
  t.extensions = %w(mp4 m4a)
end
MIME::Types.add mp4_mime_type

aac_mime_type = MIME::Type.new("audio/aac") do |t|
  t.extensions = %w(aac)
end
MIME::Types.add aac_mime_type

gtar_mime_type = MIME::Type.new("application/x-gtar") do |t|
  t.extensions = %w(gtar tgz tbz2 tbz gz)
end
MIME::Types.add gtar_mime_type

jpf_mime_type = MIME::Type.new("image/jpf") do |t|
  t.extensions = %w(jpf)
end
MIME::Types.add jpf_mime_type

dcr_mime_type = MIME::Type.new("application/x-director") do |t|
  t.extensions = %w(dcr)
end
MIME::Types.add dcr_mime_type

kml_mime_type = MIME::Type.new("application/vnd.google-earth.kml+xml") do |t|
  t.extensions = %w(kml)
end
MIME::Types.add kml_mime_type

swf_mime_type = MIME::Type.new("application/x-shockwave-flash") do |t|
  t.extensions = %w(swf)
end
MIME::Types.add swf_mime_type

wav_mime_type = MIME::Type.new("audio/wav") do |t|
  t.extensions = %w(wav)
end
MIME::Types.add wav_mime_type

# Register application mime types
Mime::Type.register 'application/x-endnote-refer', :endnote
Mime::Type.register "application/n-triples", :nt
Mime::Type.register "application/ld+json", :jsonld
Mime::Type.register "text/turtle", :ttl
