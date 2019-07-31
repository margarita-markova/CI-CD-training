#!/bin/bash

kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl patch node ${HOSTNAME} --patch='{"metadata": {"labels": {"node-role.kubernetes.io/node": ""}}}'