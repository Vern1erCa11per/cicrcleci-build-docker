FROM alpine:latest
LABEL maintainer="vern1erca1per <26157023+Vern1erCa11per@users.noreply.github.com>"

## Setup environments
ENV GOPATH  /root/go
ENV PATH    $PATH:$GOPATH/bin

## Install by apk
RUN apk add --no-cache bash curl git openssh docker go python musl-dev

## Install yq
RUN go get gopkg.in/mikefarah/yq.v2
RUN ln -s $(which yq.v2) /usr/bin/yq

## Install pip & awscli, slack-cli
RUN curl https://bootstrap.pypa.io/get-pip.py | python
RUN pip install awscli
RUN pip install slack-cli

RUN apk add -U openssl curl tar gzip bash ca-certificates && \
  wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.29-r0/glibc-2.29-r0.apk && \
  wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
  apk add glibc-2.29-r0.apk && \
  rm glibc-2.29-r0.apk

RUN curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/darwin/amd64/aws-iam-authenticator && \
    chmod +x ./aws-iam-authenticator && \
    mkdir $HOME/bin && cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && \
    export PATH=$HOME/bin:$PATH && \
    echo 'export PATH=$HOME/bin:$PATH' >> ~/.bash_profile

RUN curl -L -o /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x /usr/bin/kubectl && \
    kubectl version --client

