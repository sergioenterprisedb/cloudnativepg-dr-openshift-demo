#!/bin/bash

# Install minio
kubectl apply -f yaml/minio_openshift.yaml

# Check if the secret exists
if kubectl get secret "minio-creds" >/dev/null 2>&1; then
  echo "Secret 'minio-creds' exists. Deleting..."
  kubectl delete secret minio
fi

kubectl create secret generic minio-creds \
    --from-literal=MINIO_ACCESS_KEY=minio \
    --from-literal=MINIO_SECRET_KEY=edb-workshop

# Check if mc command exists
if command -v mc >/dev/null 2>&1; then
    echo "mc command exists."
else
    echo "mc command does not exist."
    echo "Please, install mc (Minio command line) before to continue."
    exit 1
fi

sleep 7

# Delete bucket content if exists
# Create alias openshift
mc alias rm openshift
sleep 2
mc alias set --insecure openshift https://minio-api-openshift-operators.apps-crc.testing minio edb-workshop

# List bucket
mc --insecure ls openshift      

# Remove files from cluster1 and cluster2
mc --insecure rm -r --force openshift/cnp/cluster1 > /dev/null 2>&1
mc --insecure rm -r --force openshift/cnp/cluster2 > /dev/null 2>&1
