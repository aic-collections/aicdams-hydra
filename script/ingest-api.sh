#!/bin/bash

curl -u citi:password -X POST\
 -F 'metadata[pref_label]=The Tardis'\
 -F 'metadata[visibility]=department'\
 -F 'metadata[uid]=SI-101010'\
 -F 'metadata[document_type_uri]=http://definitions.artic.edu/doctypes/ConservationStillImage'\
 -F 'metadata[depositor]=awead'\
 -F 'metadata[dept_created]=112'\
 -F 'metadata[imaging_uid][]=uid-1'\
 -F 'metadata[imaging_uid][]=uid-2'\
 -F 'content[intermediate]=@spec/fixtures/tardis.png'\
 -F 'sharing=[{ "type" : "group", "name" : "6", "access" : "read" }, {"type" : "person", "name" : "scossu", "access" : "edit"}]'\
 http://localhost:3000/api/ingest/StillImage

curl -u citi:password -X POST\
 -F 'metadata[pref_label]=Oddball text'\
 -F 'metadata[visibility]=department'\
 -F 'metadata[document_type_uri]=http://definitions.artic.edu/doctypes/General'\
 -F 'metadata[depositor]=awead'\
 -F 'content[intermediate]=@spec/fixtures/test.pdf'\
 -F 'content[0]=@spec/fixtures/text.txt'\
 http://localhost:3000/api/ingest/Text

curl -u citi:password -X POST\
 -F 'metadata[pref_label]=Multi-derivative example'\
 -F 'metadata[visibility]=authenticated'\
 -F 'metadata[document_type_uri]=http://definitions.artic.edu/doctypes/ConservationStillImage'\
 -F 'metadata[depositor]=awead'\
 -F 'content[original]=@spec/fixtures/sun.png'\
 -F 'content[pres_master]=@spec/fixtures/sun.png'\
 -F 'content[intermediate]=@spec/fixtures/sun.png'\
 http://localhost:3000/api/ingest/StillImage
