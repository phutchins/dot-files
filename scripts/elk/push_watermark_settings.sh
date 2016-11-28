#!/bin/bash

curl -XPUT 'http://localhost:9200/_cluster/settings' -d "{
  \"transient\": {
    \"cluster.routing.allocation.disk.watermark.low\": \"95%\",
    \"cluster.routing.aloocation.disk.watermark.high\": \"20gb\",
    \"cluster.info.update.interval\": \"1m\"
  }
}"
