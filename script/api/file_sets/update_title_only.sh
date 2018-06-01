#!/bin/bash

curl -i -u citi:password -X PUT\
 -F 'file_set[title][]=new title with spaces'\
 http://localhost:3000/api/file_sets/4f622807-720c-4f88-a047-eb0eb55ee375
