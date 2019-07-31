#!/bin/bash

export KUBECTL_HOME="/home/student/homework/Kubernetes/onenode"
# kubectl (run as regular user) 
# rm -rf  ~/.kube
# cp -R ${KUBECTL_HOME}/.kube ~

# # Dashboard
# # 1. kubectl proxy
# # 2. go into brouser: http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/
# # 3. token copy-paste
# # 4. check token:
# #       kubectl -n kube-system get secret
# #		kubectl -n kube-system describe secret deployment-controller-token-[your_value]

# # metrics server
# wget -P /tmp https://github.com/kubernetes-incubator/metrics-server/archive/master.zip
# unzip -d ${KUBECTL_HOME} /tmp/metrics-server-master.zip
mv ${KUBECTL_HOME}/metrics-server-master/  ${KUBECTL_HOME}/metrics-server/
kubectl apply -f ${KUBECTL_HOME}/metrics-server/deploy/1.8+/

kubectl patch deployment/metrics-server -n kube-system --patch '{
  "spec": {
    "template": {
      "spec": {
        "containers": [
          {
            "name": "metrics-server", 
            "command":[
              "/metrics-server", 
              "--kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname",
              "--kubelet-insecure-tls"
            ]
          }
        ]
      }
    }
  }
}'

cp ${KUBECTL_HOME}/metrics-server-deployment.yaml ${KUBECTL_HOME}/metrics-server/deploy/1.8+/

# for full working was needed to add lines in deployment file, but if kube fails, this file will be saved
# for super case, where I need it:
# sudo vi /home/rita/homework/kubernetes-training/day1/installation/metrics-server/deploy/1.8+/metrics-server-deployment.yaml
	# containers:
      # - command:
      #   - /metrics-server
      #   - --kubelet-insecure-tls
      #   - --kubelet-preferred-address-types=InternalIP
      #   volumeMounts:
      #   - name: tmp-dir
      #     mountPath: /tmp

kubectl apply -f ${KUBECTL_HOME}/metrics-server/deploy/1.8+/

# checking
kubectl top nodes
kubectl top pods

# custom namespace
kubectl create namespace cat-system

# change default ns to custom
kubectl config set-context --current --namespace=cat-system

# steps for architecture up:
#	https://kubernetes.io/docs/tutorials/stateless-application/guestbook/

# examples with volumes
kubectl apply -f files/volumes/pod-volumes-emptydir.yml
kubectl exec -ti pod-volumes-emptydir ls /shared-dir
kubectl exec -ti pod-volumes-emptydir ls /shared-dir-memory


