#!/bin/bash

curl -u citi:password -X POST\
 -F 'metadata[depositor]=awead'\
 -F 'content[intermediate]=@spec/fixtures/tardis2.png'\
 http://localhost:3000/api/update/233b76a6-193d-8deb-7346-593a3857f05e

curl -u citi:password -X POST\
 -F 'metadata[depositor]=awead'\
 -F 'content[legacy]=@spec/fixtures/tardis2.png'\
 http://localhost:3000/api/update/233b76a6-193d-8deb-7346-593a3857f05e

# Note: these are examples as the ids for the representations will change

curl -u citi:password -X POST\
 -F 'metadata[depositor]=awead'\
 -F 'metadata[representations_for][]=e0c47f58-5e62-45ef-a519-16afe15453dd'\
 -F 'metadata[preferred_representation_for][]=e0c47f58-5e62-45ef-a519-16afe15453dd'\
 http://localhost:3000/api/update/233b76a6-193d-8deb-7346-593a3857f05e

curl -u citi:password -X POST\
 -F 'metadata[depositor]=awead'\
 -F 'metadata[representations_for][]=e0c47f58-5e62-45ef-a519-16afe15453dd'\
 -F 'metadata[preferred_representation_for][]=e0c47f58-5e62-45ef-a519-16afe15453dd'\
 http://localhost:3000/api/update/233b76a6-193d-8deb-7346-593a3857f05e
