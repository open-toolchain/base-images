ARG DIND_IMAGE=docker:23.0.2-dind

FROM ubuntu:20.04 AS qemu-user-static
ARG QEMU_DEBIAN_VERSION=7.2+dfsg-5~bpo11+1
ARG QEMU_TAG_VERSION=v7.2.0
RUN apt-get update && \
    apt-get -y -q install curl
RUN curl -f -O http://ftp.debian.org/debian/pool/main/q/qemu/qemu-user-static_${QEMU_DEBIAN_VERSION}_amd64.deb && \
    dpkg -i  qemu-user-static_${QEMU_DEBIAN_VERSION}_amd64.deb
RUN curl -f -O https://raw.githubusercontent.com/qemu/qemu/${QEMU_TAG_VERSION}/scripts/qemu-binfmt-conf.sh && \
    chmod +x qemu-binfmt-conf.sh

ARG DIND_IMAGE
FROM ${DIND_IMAGE}
COPY --from=qemu-user-static \
  /usr/bin/qemu-arm-static \
  /usr/bin/qemu-ppc64le-static \
  /usr/bin/qemu-s390x-static \
  /usr/bin/qemu-aarch64-static \
  /usr/bin/qemu-riscv64-static /usr/local/bin/
COPY --from=qemu-user-static \
  /qemu-binfmt-conf.sh /
COPY binfmt-check.sh \
  virtiofs-check.sh /  
RUN apk add e2fsprogs && \
    sed -i '/^qemu_target_list="/{:b;$!N;/"$/!bb;s/".*"/""/}' qemu-binfmt-conf.sh && \
    sed -i 's/^qemu_target_list=""/qemu_target_list="arm ppc64le s390x aarch64 riscv64"/' qemu-binfmt-conf.sh && \
    sed -i '3 a /virtiofs-check.sh && /binfmt-check.sh\n' /usr/local/bin/dockerd-entrypoint.sh