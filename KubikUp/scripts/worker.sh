#!/bin/bash

IPADDR=$1
TOKEN=$2

if [ ! -e /etc/kubernetes/kubelet.conf ]; then
	echo "not exists"
	echo kubeadm join --token ${TOKEN} --discovery-token-unsafe-skip-ca-verification ${IPADDR}:6443
	kubeadm join --token ${TOKEN} --discovery-token-unsafe-skip-ca-verification ${IPADDR}:6443

	mkdir -p $HOME/.kube

	if [ -e /vagrant/.kube/ ]; then
	#scp root@matet:/etc/kubernetes/admin.conf   $HOME/.kube/config
	/bin/cp -f /vagrant/.kube/config $HOME/.kube/config
	chown $(id -u):$(id -g) $HOME/.kube/config
	fi

	kubectl patch node ${HOSTNAME} --patch='{"metadata": {"labels": {"node-role.kubernetes.io/node": ""}}}'
fi

#     while sudo kubectl get nodes | grep $(hostname) | grep NotReady >/dev/null;
#     do
#         echo $(date +"[%H:%M:%S]") Worker $(hostname) is not ready yet
#         sleep 30
#     done

#     echo $(date +"[%H:%M:%S]") Worker $(hostname) is Ready
# fi

# sudo kubectl get nodes