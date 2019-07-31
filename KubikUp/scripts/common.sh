#!/bin/bash

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

yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum-config-manager --enable docker-ce-edge
yum install -y docker-ce-18.09.0 runc #docker-ce-cli containerd.io

systemctl enable docker 

mkdir -p /etc/docker

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
EOF


if [ -n "${VERSION}" ]; then
  yum install -y kubelet-${VERSION} kubeadm-${VERSION} kubectl-${VERSION} kubernetes-cni 
else
  yum install -y kubelet kubeadm kubectl kubernetes-cni --disableexcludes=kubernetes
fi

systemctl start docker
systemctl enable kubelet

# Host Internal IP: 192.168.56. ...
IPADDR=$(hostname -I | sed 's/10.0.2.15//' | awk '{print $1}')
sed -i "s/\(KUBELET_EXTRA_ARGS=\).*/\1--node-ip=${IPADDR}/" /etc/sysconfig/kubelet