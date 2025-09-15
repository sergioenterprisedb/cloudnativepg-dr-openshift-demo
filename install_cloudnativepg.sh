#!/bin/bash

# Author      : Sergio Romera
# Created     : 10/03/2022
# Description : Install CNP cluster

. ./config_cloudnativepg.sh

function check_deployment()
{
  status=0
  sp="/-\|"

  while [ $status -ne 1 ]
  do
    printf "\b${sp:i++%${#sp}:1}"
    status=`kubectl get deploy -n ${deployment} | sed -n 2p | awk '{print $4}'`
    sleep 1 
  done

  printf "\b"
  msg "kubectl get deploy -n ${deployment} -o wide"
  kubectl get deploy -n ${deployment} -o wide

}

function check_cluster()
{
  status=0
  counter=1
  instances=0
  instances=`grep instances ${cluster_file1} | awk '{print $2}' | cut -c1`
  sp="/-\|"
    
  #sleep 5
  #msg "kubectl-cnpg status ${cluster_name}"

  while [ $status -ne $instances ]
  do
    sleep 1

    status=`echo $status | xargs`
    printf "\rNumber of pods created: $status ${sp:i++%${#sp}:1}"
    #"^[[32m3^[[0m"
    if [ `expr $counter % 5` -eq 0 ]; then
      #status=`kubectl-cnpg status ${cluster_name} | grep 'Ready' | awk '{print $3}' | cut -c6`
      status=`kubectl get pod | grep "1/1" | grep Running | grep ${cluster_name} | wc -l`
      if [ -z "$status" ]; then
        status=0
      fi
      #status=${status:5:1}
      #echo "yes"
    fi
    (( counter++ ))

  done

  status=`echo $status | xargs`
  printf "\b\rNumber of pods created: $status"
  printf "\n"

}

function install_plugin()
{
  msg "curl -sSfL ${pluging} | sh -s -- -b /usr/local/bin"
  curl -sSfL ${pluging} | sudo sh -s -- -b /usr/local/bin
}

function msg()
{
  printf "${green}$1${reset}\n"
}

function object_storage_config ()
{
  if [ ${OBJECT_STORAGE} == "MINIO" ]; then
    #install_minio_client
    printf "MinIO started\n"
    cp ${S3_MINIO_DIRECTORY}/*.yaml .
  fi
}

function replace_config()
{
  # MINIO
  sed -i '' -e "s|###IMAGENAME###|${IMAGENAME}|g" cluster*.yaml
  sed -i '' -e "s|###MINIO_DESTINATIONPATH###|${MINIO_DESTINATIONPATH}|g" cluster*.yaml
  sed -i '' -e "s|###MINIO_ENDPOINTURL###|${MINIO_ENDPOINTURL}|g" cluster*.yaml
}

#Install CloudNativePG
start=$SECONDS

echo "********************************"
echo "*** Configure Object Storage ***"
echo "********************************"
object_storage_config

echo "*****************************************"
echo "*** Installing CloudNativePG Plugging ***"
echo "*****************************************"
install_plugin

echo "*********************************************"
echo "*** Verify install CloudNativePG Operator ***"
echo "*********************************************"
check_deployment

echo "**********************"
echo "*** Replace config ***"
echo "**********************"
replace_config

echo "***********************"
echo "*** Install cluster ***"
echo "***********************"
msg "kubectl apply -f ${cluster_file1}"
kubectl apply -f ${cluster_file1}
check_cluster

echo "***************************"
echo "*** Show cluster status ***"
echo "***************************"
kubectl-cnpg status ${cluster_name}

end=$SECONDS
echo "Duration: "
echo "***********************************************"
echo "*** Installation successfully in $((end-start)) seconds ***"
echo "***********************************************"
echo "Execute this command to check the cluster status:"
echo ""
msg "kubectl-cnpg status ${cluster_name}"
echo ""

