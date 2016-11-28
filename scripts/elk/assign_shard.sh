#!/bin/bash

# Useful commands & one liners
# curl -s localhost:9200/_cat/shards | grep UNASS

# Update number_of_replicas setting for all indices with unassigned shards to 0
# This is useful for a single node which is in yellow status due to unassigned shards that are waiting for a second host to come on line
# curl -s localhost:9200/_cat/shards | grep UNASS | while read -r line; do line_arr=($line); curl -XPUT "localhost:9200/${line_arr[0]}/_settings" -d ' { "index": { "number_of_replicas" : 0 } } '; done
# If you use the command above, you will still likely want to set the number_of_replicas in the template for that index which
# will affect all new indices created in the future
# curl -XPUT https://logs.storj.io:9900/logstash-*/_settings -d ' { "number_of_replicas": 2 } '

if [ -z "$1" ]; then
  echo "Manually assign shards per index for all instances of this shard"
  echo "Usage: assign_shard [index] [node_name] [shard_count]"
  echo "or"
  echo "Automatically assign all unassigned shards to [node_name]"
  echo "Usage: assign_shard [node_name]"
  exit 1;
fi

shassign () {
  if [ -z "$1" ]
  then
    echo "No shards provided to assign... :("
  else
    echo "Assigning index $1 shard count $2 to node $3"
  fi

  INDEX=$1
  SHARD_NUM=$2
  NODE=$3

  echo "curl -XPOST 'http://localhost:9200/_cluster/reroute?pretty' -d \"{
      \"commands\": [{
          \"allocate\": {
              \"index\": \"$INDEX\",
              \"shard\": $SHARD_NUM,
              \"node\": \"$NODE\",
              \"allow_primary\": 1
          }
      }]
  }\""

  curl -XPOST 'http://localhost:9200/_cluster/reroute?pretty' -d "{
      \"commands\": [{
          \"allocate\": {
              \"index\": \"$INDEX\",
              \"shard\": $SHARD_NUM,
              \"node\": \"$NODE\",
              \"allow_primary\": 1
          }
      }]
  }"

  echo "Index $INDEX shard count $SHARD_NUM assigned to $NODE"
}

# Manually assign a single index with a shard count
if [ "$#" -eq 3 ]; then
  INDEX=$1
  NODE=$2
  SHARD_COUNT=$3
  INDEXES=( INDEX )

  for shnum in `seq 0 $SHARD_COUNT`; do
    shassign $INDEX $shnum $NODE
  done
fi

if [ "$#" -eq 1 ]; then
  NODE=$1
  unassigned_shards=$(curl -s localhost:9200/_cat/shards | grep UNASS)

  if [ -z "$unassigned_shards" ]; then
    echo "No unassigned shards found"
    exit 0;
  fi

  while read -r shard_line; do
    output_array=($shard_line)
    index=${output_array[0]}
    shnum=${output_array[1]}

    shassign $index $shnum $NODE
  done <<< "$unassigned_shards"
fi

