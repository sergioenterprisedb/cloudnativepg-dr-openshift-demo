#!/bin/bash

echo "Creating table rep_test in cluster1"
echo "create table rep_test (id int);" | kubectl-cnpg psql cluster1
echo "Verifing table creationg in cluster2"
sleep 2
echo "\d rep_test" | kubectl-cnpg psql cluster1

