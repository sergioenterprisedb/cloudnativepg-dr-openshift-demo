#!/bin/bash

# Author      : Sergio Romera
# Created     : 10/03/2022
# Description : Config file

export PGUSER=postgres
export version1=`kubectl-cnpg version | awk '{ print $2 }' | awk -F":" '{ print $2}'`
export version2=${version1%??}
export pluging="https://github.com/cloudnative-pg/cloudnative-pg/raw/main/hack/install-cnpg-plugin.sh"
export operator="https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/release-${version2}/releases/cnpg-${version1}.yaml"
export deployment="openshift-operators cnpg-controller-manager"
export cluster_file1="cluster1.yaml"
export cluster_file2="cluster2.yaml"
export cluster_name="cluster1"
export S3_MINIO_DIRECTORY="./S3_MINIO"

# MINIO
export OBJECT_STORAGE="MINIO"
export IMAGENAME="ghcr.io/cloudnative-pg/postgresql:16.2"

# MinIO config
export MINIO_DESTINATIONPATH="s3://cnp/"
export MINIO_PORT=9000
export MINIO_ENDPOINTURL="https://minio-api-openshift-operators.apps-crc.testing"

# **************
# *** Colors ***
# **************
reset="\e[0m"
green="\e[32m"
red="\e[31m"
default="\e[39m"

