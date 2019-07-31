#!/bin/bash

#Installing kubectl
yum install -y deltarpm
yum update  -y
yum install -y epel-release wget ntp jq git net-tools bind-utils moreutils

getenforce | grep Disabled || setenforce 0
echo "SELINUX=disabled" > /etc/sysconfig/selinux

# Disable SWAP (As of release Kubernetes 1.8.0, kubelet will not work with enabled swap.)
sed -i '/swap/d' /etc/fstab
swapoff --all

systemctl start ntpd
systemctl enable ntpd

docker info | grep "Cgroup Driver: systemd"
if [ $? -ne 0 ]; then
    echo "Updating Docker settings"
    if [ -f /etc/docker/daemon.json ]; then
        cat /etc/docker/daemon.json | \
            jq '."exec-opts" |= .+ ["native.cgroupdriver=systemd"]' | \
            sponge /etc/docker/daemon.json
    else
        echo "{}" | \
        jq '."exec-opts" |= .+ ["native.cgroupdriver=systemd"]' > \
        /etc/docker/daemon.json
    fi
    echo "cat /etc/docker/daemon.json:"
    cat /etc/docker/daemon.json
    echo 
    systemctl restart docker || exit 1
fi

cat <<EOF >  /etc/sysctl.d/docker.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF

yum install -y kubectl --disableexcludes=kubernetes

# Configuring kubectl Access to cluster
# mkdir -p $HOME/.kube 
# /bin/cp -f admin.conf $HOME/.kube/config 

#OR
export KUBECONFIG=/home/rita/homework/kubernetes-training/day1/installation/.kube/config

# kubectl get nodes
# kubectl config current-context
# kubectl cluster-info


#Configure kubectl bash completion
yum install -y bash-completion
echo "source <(kubectl completion bash)" >> ~/.bashrc