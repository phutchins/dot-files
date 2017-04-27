#!/bin/bash
storj list-buckets | while read line; do storj remove-bucket -f $(echo $line | sed -E 's/^.*ID: ([^,]+), .*$/\1/') ; done
