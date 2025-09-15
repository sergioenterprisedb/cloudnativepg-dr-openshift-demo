#!/bin/bash

. ./config_cloudnativepg.sh

echo "select pg_switch_wal()" | kubectl-cnpg psql cluster2

printf "${green}kubectl apply -f cluster1_wal_streaming_restore.yaml${reset}\n"

kubectl apply -f cluster1_wal_streaming_restore.yaml

