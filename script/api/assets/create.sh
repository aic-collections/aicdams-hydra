#!/bin/bash

curl -u citi:password -X POST\
 -F 'metadata[pref_label]=The Tardis'\
 -F 'metadata[visibility]=department'\
 -F 'metadata[uid]=SI-101010'\
 -F 'metadata[document_type_uri]=http://definitions.artic.edu/doctypes/ConservationStillImage'\
 -F 'metadata[depositor]=laketest'\
 -F 'metadata[dept_created]=112'\
 -F 'metadata[imaging_uid][]=uid-1'\
 -F 'metadata[imaging_uid][]=uid-2'\
 -F 'content[intermediate]=@spec/fixtures/tardis.png'\
 -F 'sharing=[{ "type" : "group", "name" : "6", "access" : "read" }, {"type" : "person", "name" : "scossu", "access" : "edit"}]'\
 http://localhost:3000/api/ingest/StillImage
