FROM centos:latest
RUN yum install -y epel-release && \
	yum update -y && \
	yum install -y docker-ce-cli && \
	yum install -y containerd.io
CMD ["sleep", "1000"]