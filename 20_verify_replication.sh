#!/bin/bash

echo "Creating table rep_test2 in cluster2"
echo "create table rep_test2 (id int);" | kubectl-cnpg psql cluster2
echo "Verifing table creation in cluster1"
sleep 2
echo "\d rep_test2" | kubectl-cnpg psql cluster1

