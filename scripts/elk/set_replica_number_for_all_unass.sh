#!/bin/bash

unassigned_shards=$(curl -s localhost:9200/_cat/shards | grep UNASS);
while read -r line; do
  line_arr=($line);
  curl -XPUT "localhost:9200/${line_arr[0]}/_settings" -d ' { "INDEX": { "number_of_replicas": 0 } } ';
done <<< "$unassigned_shards"
