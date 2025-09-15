#!/bin/bash

# The OpenShift/CRC router uses its own CA to sign all *.apps-crc.testing files.
oc get secret -n openshift-ingress-operator router-ca \
  -o jsonpath='{.data.tls\.crt}' | base64 -d > crc-router-ca.crt

# CloudNativePG allows you to pass the CA to backup tools.
oc create secret generic crc-router-ca --from-file=ca.crt=crc-router-ca.crt
