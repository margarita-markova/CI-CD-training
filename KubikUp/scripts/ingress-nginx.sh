#!/bin/bash

version="nginx-0.24.1"
sudo kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/${version}/deploy/mandatory.yaml

#is_metallb=${1}

# if [ "${is_metallb}" == "true" ]; then
#   sudo kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/${version}/deploy/provider/cloud-generic.yaml
# else
sudo kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/${version}/deploy/provider/baremetal/service-nodeport.yaml
IPADDR=$(sudo kubectl get node -l node-role.kubernetes.io/master -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
sudo kubectl patch svc ingress-nginx -n ingress-nginx --patch '{ "spec": {"externalIPs": [ "'${IPADDR}'" ] }}'
# fi

# while [ "$(sudo kubectl get pod -n ingress-nginx -o jsonpath='{.items[0].status.phase}')" != "Running" ]; do
#   echo $(date +"[%H:%M:%S]") Nginx Ingress Controller not Ready
#   sleep 10
# done

# sudo kubectl get svc -n ingress-nginx