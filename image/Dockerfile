FROM kudulab/k8s-dojo:1.1.1

# Install aws cli version 2 (validate the files using the PGP signature)
# https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html
# It does not work by default on Alpine Linux, thus we need glibc to fix it:
# https://github.com/aws/aws-cli/issues/4685#issuecomment-615872019
RUN apk add --no-cache unzip gnupg nano
COPY aws.gpg /opt/aws.gpg
ENV GLIBC_VER=2.31-r0
RUN apk --no-cache add \
        binutils \
        curl \
    && curl -sL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk \
    && apk add --no-cache \
        glibc-${GLIBC_VER}.apk \
        glibc-bin-${GLIBC_VER}.apk &&\
  curl -o awscliv2.sig https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip.sig &&\
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" &&\
  gpg --import /opt/aws.gpg &&\
  gpg --verify awscliv2.sig awscliv2.zip &&\
  unzip awscliv2.zip &&\
  ./aws/install

# groff less are needed to read aws cli help
# jq is to read json files
RUN apk add --no-cache groff less jq
# Install eksctl
# https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html
ENV EKSCTL_VERSION=0.20.0
RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/${EKSCTL_VERSION}/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp &&\
  mv /tmp/eksctl /usr/local/bin

# install kops
ENV KOPS_VERSION=1.16.2
RUN wget -O /tmp/kops-linux-amd64 https://github.com/kubernetes/kops/releases/download/v${KOPS_VERSION}/kops-linux-amd64 &&\
  chmod +x /tmp/kops-linux-amd64 &&\
  mv /tmp/kops-linux-amd64 /usr/local/bin/kops

# install bats-core
ENV BATS_CORE_VERSION=1.2.0
RUN cd /tmp &&\
  git clone --depth 1 -b v${BATS_CORE_VERSION} https://github.com/bats-core/bats-core.git &&\
  cd bats-core &&\
  ./install.sh /opt &&\
  cd .. && rm -r bats-core &&\
  ln -s /opt/bin/bats /usr/bin/bats &&\
  apk --no-cache add ncurses

COPY etc_dojo.d/scripts/* /etc/dojo.d/scripts/
# COPY etc_dojo.d/variables/* /etc/dojo.d/variables/
COPY bashrc /home/dojo/.bashrc
RUN chown dojo:dojo /home/dojo/.bashrc

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["/bin/bash"]
