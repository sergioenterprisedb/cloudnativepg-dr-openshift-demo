#!/bin/bash

# Author      : Sergio Romera
# Created     : 10/03/2022
# Description : Delete cluster1

. ./config_cloudnativepg.sh

# Delete yamls
kubectl delete -f cluster1.yaml
kubectl delete -f cluster2.yaml
kubectl delete -f yaml/backup_cluster1.yaml
kubectl delete -f yaml/backup_cluster2.yaml
kubectl delete -f app-secret.yaml
kubectl delete secret minio-creds
kubectl delete secret app-secret
kubectl delete secret crc-router-ca

rm crc-router-ca.crt
rm cluster1_wal_streaming_restore.yaml
rm cluster2_restore.yaml
rm cluster2_wal_streaming.yaml
rm cluster1.yaml
rm cluster2_wal_streaming_backup.yaml
rm cluster2.yaml

mc --insecure rm -r --force openshift/cnp/cluster1
mc --insecure rm -r --force openshift/cnp/cluster2

# Delete minio
kubectl delete -f yaml/minio_openshift.yaml
