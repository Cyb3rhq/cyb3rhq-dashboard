FROM centos:latest

RUN mkdir -p /tmp
FROM centos
ARG PACKAGE
RUN cd /etc/yum.repos.d/
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
RUN yum update -y
COPY ${PACKAGE} /tmp/cyb3rhq.rpm
RUN yum install /tmp/cyb3rhq.rpm -y
