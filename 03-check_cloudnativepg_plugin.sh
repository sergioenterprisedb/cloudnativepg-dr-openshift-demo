#!/bin/bash

# Check if mc command exists
if command -v kubectl-cnpg >/dev/null 2>&1; then
  echo "CloudNativePG plugin (kubectl-cnpg) command exists."
  version1=`kubectl-cnpg version | awk '{ print $2 }' | awk -F":" '{ print $2}'`
  version2=${version1%??}
  echo "kubectl-cnpg version: $version1"
else
  echo "CloudNativePG plugin (kubectl-cnpg) command does not exist."
  echo "Please, install CloudNativePG plugin (kubectl-cnpg) before to continue."
  exit 1
fi

