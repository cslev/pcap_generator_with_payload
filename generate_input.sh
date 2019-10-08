#!/bin/bash

for ip in `cat source/source_ip.txt`; do
  SOURCE_IP=$ip
  DEST_PORT=$(((RANDOM % 32768) + 28232))
  for i in `seq 1 $((RANDOM % 1024))`; do
      echo "src_mac=00:00:00:00:00:01,dst_mac=00:00:00:00:00:02, src_ip=$SOURCE_IP, dst_ip=10.0.0.2, src_port=53,dst_port=$DEST_PORT,payload=dns_example.payload"
  done;
done;
