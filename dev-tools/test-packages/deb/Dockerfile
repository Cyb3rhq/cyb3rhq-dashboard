FROM ubuntu:jammy
ARG PACKAGE
RUN mkdir -p /tmp
RUN apt-get update --fix-missing
RUN apt-get install -y curl libcap2-bin
COPY ${PACKAGE} /tmp/cyb3rhq.deb
RUN dpkg -i /tmp/cyb3rhq.deb
