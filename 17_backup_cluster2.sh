#!/bin/bash

. ./config_cloudnativepg.sh
printf "${green}kubectl apply -f yaml/backup_cluster2.yaml${reset}\n"

kubectl apply -f yaml/backup_cluster2.yaml

