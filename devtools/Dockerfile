##########################################################################################
# Licensed Materials - Property of IBM
# (c) Copyright IBM Corporation 2023. All Rights Reserved.
#
# Note to U.S. Government Users Restricted Rights:
# Use, duplication or disclosure restricted by GSA ADP Schedule
# Contract with IBM Corp.
##########################################################################################
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN apt-get -q update \
    && apt-get install -y apt-utils software-properties-common \
    && add-apt-repository ppa:git-core/ppa \
    && apt-get -q update \
    && apt-get upgrade -y \
    && apt-get -q clean \
    && apt-get -q install -y apt-transport-https zip unzip git dnsutils curl gettext wget ca-certificates openssl locales make \
    && wget --quiet -O script.sh https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh \
    && bash script.sh \
    && rm -f script.sh \
    && apt-get -q install git-lfs \
    && git lfs install \
    && apt-get -q clean \
    && rm -rf /var/lib/apt/lists \
    && locale-gen en_US.UTF-8 \
    && apt-get remove -y software-properties-common \
    && apt-get autoremove -y

ENV LANG=en_US.UTF-8

RUN git config --global url."https://".insteadOf git:// \
    && git config --global http.postBuffer 1048576000

#Install scripts
COPY scripts /opt/IBM/bin/

# Install kubectl
ARG KUBECTL_VERSION='v1.25.6'
RUN wget --quiet --output-document=/usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
    && chmod +x /usr/local/bin/kubectl

# Install Helm3
ARG HELM3_VERSION='v3.11.2'
RUN mkdir -p /tmp/helm_install \
    && wget --quiet https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get -O get_helm.sh \
    && chmod 700 get_helm.sh \
    && ./get_helm.sh --version ${HELM3_VERSION} \
    && rm -rf /tmp/helm*

# Install JQ 1.x
ARG JQ_VERSION='1.6'
RUN wget --quiet --no-check-certificate https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 -O /tmp/jq-linux64 \
    && cp /tmp/jq-linux64 /usr/bin/jq \
    && chmod +x /usr/bin/jq \
    && rm -f /tmp/jq-linux64

ENV IBMCLOUD_VERSION='2.15.0'
RUN wget --quiet -O /tmp/Bluemix_CLI.tar.gz https://download.clis.cloud.ibm.com/ibm-cloud-cli/${IBMCLOUD_VERSION}/IBM_Cloud_CLI_${IBMCLOUD_VERSION}_amd64.tar.gz \
    && tar -xzvf /tmp/Bluemix_CLI.tar.gz -C /tmp \
    && /tmp/Bluemix_CLI/install_bluemix_cli \
    && rm -rf /tmp/Bluemix_CLI* \
    && ibmcloud config --check-version false

RUN ibmcloud plugin install container-service -r 'IBM Cloud' -v 1.0.498 \
    && ibmcloud plugin install container-registry -r 'IBM Cloud' -v 1.0.6 \
    && ibmcloud plugin install cloud-functions -r 'IBM Cloud' -v 1.0.64 \
    && ibmcloud plugin install schematics -r 'IBM Cloud' -v 1.12.7 \
    && ibmcloud plugin install doi -r 'IBM Cloud' -v 0.4.1 \
    && ibmcloud plugin install cis -r 'IBM Cloud' -v 1.14.9 \
    && ibmcloud plugin install cra -r 'IBM Cloud' -v 1.1.5 \
    && ibmcloud plugin install code-engine -r 'IBM Cloud' -v 1.41.3 \
    && ibmcloud plugin install secrets-manager -r 'IBM Cloud' -v 0.1.25

RUN ln -s /usr/local/ibmcloud/bin/ibmcloud /usr/local/bin/ic

# Install OpenShift CLI
RUN wget --quiet -O /tmp/oc.tar.gz https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/openshift-client-linux.tar.gz \
    && tar xzvf /tmp/oc.tar.gz -C /tmp/ \
    && mv /tmp/oc /usr/local/bin/ \
    && rm -f /tmp/oc.tar.gz /tmp/oc /tmp/kubectl

# terraform
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update -qq && apt-get -y -qq install gpg lsb-release \
    && wget --quiet -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor > /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" > /etc/apt/sources.list.d/hashicorp.list \
    && apt-get update -qq && apt-get install -y -qq terraform \
    && rm -f /etc/apt/sources.list.d/hashicorp.list \
    && rm -rf /var/lib/apt/lists

# Install yq v4.x
ENV YQ4_VERSION=v4.32.2
RUN wget --quiet -O yq4_linux_amd64 https://github.com/mikefarah/yq/releases/download/${YQ4_VERSION}/yq_linux_amd64 \
    && mv yq4_linux_amd64 /usr/bin/yq \
    && chmod +x /usr/bin/yq

# Install buildctl
ENV BUILDKIT_VERSION=v0.11.4
RUN wget --quiet -O buildkit-${BUILDKIT_VERSION}.linux-amd64.tar.gz https://github.com/moby/buildkit/releases/download/${BUILDKIT_VERSION}/buildkit-${BUILDKIT_VERSION}.linux-amd64.tar.gz \
    && tar zxvf buildkit-${BUILDKIT_VERSION}.linux-amd64.tar.gz --strip-components 1 -C /usr/bin bin/buildctl \
    && rm -f buildkit-${BUILDKIT_VERSION}.linux-amd64.tar.gz

# install docker CLI
ENV DOCKER_VERSION=20.10.23
RUN wget --quiet -O docker-${DOCKER_VERSION}.tgz https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz \
    && tar zxvf docker-${DOCKER_VERSION}.tgz --strip-components 1 -C /usr/bin docker/docker \
    && rm -f docker-${DOCKER_VERSION}.tgz    

ENV TMPDIR=/tmp
ENV HOME=/root
ENV PATH /opt/IBM/bin:$PATH
