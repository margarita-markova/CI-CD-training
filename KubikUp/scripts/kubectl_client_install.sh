#!/bin/bash

export KUBECTL_HOME="/home/student/homework/Jenkins/day4/KubikUp"
# kubectl (run as regular user) 
rm -rf  ~/.kube
cp -R ${KUBECTL_HOME}/.kube ~